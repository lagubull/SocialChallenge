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

/**
 Identifies the object.
 */
@property (nonatomic, strong) NSString *title;

@end

@implementation JSCDownloadTaskInfo

#pragma mark - Init

- (instancetype)initWithFileTitle:(NSString *)title
                              URL:(NSURL *)url
                  completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSURL *location, NSError *error))completionHandler
{
    self = [super init];
    
    if (self)
    {
        _task = [[JSCSession session] downloadTaskWithURL:url];
        _title = title;
        _url = url;
        _downloadProgress = 0.0;
        _isDownloading = NO;
        _downloadComplete = NO;
        _completionHandler = completionHandler;
        _taskIdentifier = [@(_task.taskIdentifier) stringValue];
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