//
//  JSCDownloadTaskInfo.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCDownloadTaskInfo.h"

#import "JSCSession.h"

@interface JSCDownloadTaskInfo ()

@end

@implementation JSCDownloadTaskInfo

#pragma mark - Init

- (instancetype)initWithDownloadID:(NSString *)downloadId
                               URL:(NSURL *)url
                   completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error))completionHandler
{
    self = [super init];
    
    if (self)
    {
        _task = [[JSCSession session] downloadTaskWithURL:url];
        _downloadId = downloadId;
        _url = url;
        _downloadProgress = 0.0;
        _isDownloading = NO;
        _downloadComplete = NO;
        _completionHandler = completionHandler;
    }
    
    return self;
}


#pragma mark - Pause

- (void)pause
{
    self.isDownloading = NO;
    
    [self.task suspend];
    
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData)
     {
         self.taskResumeData = [[NSData alloc] initWithData:resumeData];
     }];
}

#pragma mark - Resume

- (void)resume
{
    if (self.taskResumeData.length > 0)
    {
        NSLog(@"Resuming task - %@", self.downloadId);
        
        self.task = [[JSCSession session] downloadTaskWithResumeData:self.taskResumeData];
    }
    else
    {
        if (self.task.state == NSURLSessionTaskStateCompleted)
        {
            NSLog(@"Resuming task - %@", self.downloadId);
            
            //we cancelled this operation before it actually started
            self.task = [[JSCSession session] downloadTaskWithURL:self.url];
        }
        else
        {
            NSLog(@"Starting task - %@", self.downloadId);
        }
    }
    
    self.isDownloading = YES;
    
    [self.task resume];
}

#pragma mark - Coalescing

- (BOOL)canCoalesceWithTaskInfo:(JSCDownloadTaskInfo *)taskInfo
{
    return [self.downloadId isEqualToString:taskInfo.downloadId];
}

- (void)coalesceWithTaskInfo:(JSCDownloadTaskInfo *)taskInfo
{
    // Success coalescing
    void (^myCompletionHandler)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error) = [_completionHandler copy];
    void (^theirCompletionHandler)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error) = [taskInfo->_completionHandler copy];
    
    self.completionHandler = ^(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error)
    {
        if (myCompletionHandler)
        {
            myCompletionHandler(downloadTask, responseData, location, error);
        }
        
        if (theirCompletionHandler)
        {
            theirCompletionHandler(downloadTask, responseData, location, error);
        }
    };
}

@end