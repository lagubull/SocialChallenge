//
//  JSCDownloadTaskInfo.h
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import <Foundation/Foundation.h>

#import "JSCSession.h"

/**
 Represents a download task and its metadata.
 */
@interface JSCDownloadTaskInfo : NSObject

/**
 Identifies the object.
 */
@property (nonatomic, strong) NSString *downloadId;

/**
 Data already downloaded.
 */
@property (nonatomic, strong) NSData *taskResumeData;

/**
 Progress of the download.
 */
@property (nonatomic, assign) double downloadProgress;

/**
 Indicates whethere the task is executing.
 */
@property (nonatomic, assign) BOOL isDownloading;

/**
 Indicates where the download has finished.
 */
@property (nonatomic, assign) BOOL downloadComplete;

/**
 The task itself.
 */
@property (nonatomic, strong) NSURLSessionDownloadTask *task;

/**
 Identifies the object.
 */
@property (nonatomic, copy) NSString *taskIdentifier;

/**
 Block to be executed upon finishing.
 */
@property (nonatomic, copy) void (^completionHandler)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error);

/**
 Path to be downloaded.
 */
@property (nonatomic, strong) NSURL *url;

/**
 Creates a new DownloadTaskInfo object.
 
 @param title - used to identify the task.
 @param url - URL task will download from.
 @param completionBlock -  Block to be executed upon finishing.
 
 @return Instance of the class.
 */
- (instancetype)initWithDownloadID:(NSString *)dowloadId
                               URL:(NSURL *)url
                   completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error))completionHandler;

/**
 Stops the task and stores the progress.
 */
- (void)pause;

/**
 Starts the task.
 */
- (void)resume;

/**
 Checks weather the taskInfo provided equals self.
 
 @param taskInfo - new task.
 */
- (BOOL)canCoalesceWithTaskInfo:(JSCDownloadTaskInfo *)taskInfo;

/**
 Merges a new task with self.
 
 @param taskInfo - new task.
 */
- (void)coalesceWithTaskInfo:(JSCDownloadTaskInfo *)taskInfo;

@end
