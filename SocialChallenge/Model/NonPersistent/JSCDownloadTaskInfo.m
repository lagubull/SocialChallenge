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

@end