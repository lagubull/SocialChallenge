//
//  JSCSession.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCSession.h"

#import "JSCStack.h"
#import "JSCDownloadTaskInfo.h"

/**
 Constant to indicate cancelled task.
 */
static NSInteger const kCancelled = -999;

@interface JSCSession () <NSURLSessionDownloadDelegate>

/**
 Stack to store the pending downloads.
 */
@property (nonatomic, strong) JSCStack *downloadStack;

/**
 Current download.
 */
@property (nonatomic, strong) JSCDownloadTaskInfo *inProgressDownload;

/**
 Session Object.
 */
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation JSCSession

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [configuration setHTTPMaximumConnectionsPerHost:1];
        
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:self
                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        _downloadStack = [[JSCStack alloc] init];
    }
    
    return self;
}

+ (JSCSession *)session
{
    static JSCSession *session = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      
                      [configuration setHTTPMaximumConnectionsPerHost:100];
                      
                      session = [[self alloc] init];
                  });
    
    return session;
}

#pragma mark - ScheduleDownload

+ (void)scheduleDownloadWithID:(NSString *)downloadID
                       fromURL:(NSURL *)url
                completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error))completionHandler
{
    JSCDownloadTaskInfo *task = [[JSCDownloadTaskInfo alloc] initWithDownloadID:downloadID
                                                                     URL:url
                                                         completionBlock:completionHandler];
    
    [[JSCSession session].downloadStack push:task];
    
    [JSCSession resumeDownloads];
}

#pragma mark - ForceDownload

+ (void)forceDownloadWithID:(NSString *)downloadID
                    fromURL:(NSURL *)url
             completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error))completionHandler
{
    [JSCSession pauseDownloads];
    
    [JSCSession scheduleDownloadWithID:downloadID
                               fromURL:url
                             completionBlock:completionHandler];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if (self.inProgressDownload.task.taskIdentifier == downloadTask.taskIdentifier)
    {
        if (self.inProgressDownload.completionHandler)
        {
            NSData * data  = [NSData dataWithContentsOfFile:[location path]];
            
            self.inProgressDownload.completionHandler(self.inProgressDownload, data, location, nil);
        }
        
        self.inProgressDownload = nil;
        
        [JSCSession resumeDownloads];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.inProgressDownload)
    {
        self.inProgressDownload.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        [self.delegate didUpdateProgress:self.inProgressDownload];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error &&
        error.code != kCancelled)
    {
        if (self.inProgressDownload.task.taskIdentifier == task.taskIdentifier &&
            self.inProgressDownload.completionHandler)
        {
            self.inProgressDownload.completionHandler(self.inProgressDownload, nil, nil, error);
        }

        //  Handle error
        NSLog(@"task: %@ Error: %@", self.inProgressDownload.downloadId, error);
        
        [JSCSession resumeDownloads];
    }
}

#pragma mark - Cancel

+ (void)cancelDownloads
{
    [[JSCSession session].inProgressDownload.task cancel];
    [JSCSession session].inProgressDownload = nil;
    [[JSCSession session].downloadStack clear];
}

#pragma mark - Resume

+ (void)resumeDownloads
{
    if (![JSCSession session].inProgressDownload)
    {
        [JSCSession session].inProgressDownload = [[JSCSession session].downloadStack pop];
    }
    
    if ([JSCSession session].inProgressDownload &&
        ![JSCSession session].inProgressDownload.isDownloading)
    {
        if ([JSCSession session].inProgressDownload.taskResumeData.length > 0)
        {
            NSLog(@"Resuming task - %@", [JSCSession session].inProgressDownload.downloadId);
            
            [JSCSession session].inProgressDownload.task = [[JSCSession session].session downloadTaskWithResumeData:[JSCSession session].inProgressDownload.taskResumeData];
        }
        else
        {
            if ([JSCSession session].inProgressDownload.task.state == NSURLSessionTaskStateCompleted)
            {
                //we cancelled this operation before it actually started
                [JSCSession session].inProgressDownload.task = [[JSCSession session].session downloadTaskWithURL:[JSCSession session].inProgressDownload.url];
            }
            else
            {
                NSLog(@"Starting task - %@", [JSCSession session].inProgressDownload.downloadId);
            }
        }
        
        [JSCSession session].inProgressDownload.isDownloading = YES;
        [[JSCSession session].inProgressDownload.task resume];
        
        [[JSCSession session].delegate didResumeDownload:[JSCSession session].inProgressDownload];
    }
}

#pragma mark - Pause

+ (void)pauseDownloads
{
    if ([JSCSession session].inProgressDownload)
    {
        NSLog(@"Pausing task - %@", [JSCSession session].inProgressDownload.downloadId);
        
        [[JSCSession session].inProgressDownload pause];
        
        [[JSCSession session].downloadStack push:[JSCSession session].inProgressDownload];
        
        [JSCSession session].inProgressDownload = nil;
    }
}

#pragma mark - NSURLSessionDownloadTask

- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url
{
    return [[JSCSession session].session downloadTaskWithURL:url];
}

#pragma mark - NSURLSessionDataTask

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    return [[JSCSession session].session dataTaskWithRequest:request
                                           completionHandler:completionHandler];
}

@end