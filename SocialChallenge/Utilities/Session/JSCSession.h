//
//  JSCSession.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

@class JSCDownloadTaskInfo;

/**
 Protocol to indicate the status of the downloads.
 */
@protocol JSCSessionDelegate <NSObject>

/**
 Notifies the delegate a download has been resumed.
 
 @param downloadTaskInfo - metadata on the resumed download.
 */
- (void)didResumeDownload:(JSCDownloadTaskInfo *)downloadTaskInfo;

/**
 Notifies the delegate a download has progressed.
 
 @param downloadTaskInfo - metadata on the download.
 */
- (void)didUpdateProgress:(JSCDownloadTaskInfo *)downloadTaskInfo;

@end

/**
 Defines a session with custom methods to download.
 */
@interface JSCSession : NSObject

/**
 Stop and remove all the pending downloads without executing the completion block.
 */
+ (void)cancelDownloads;

/**
 Resume or starts the next pending download if it is not already executing.
 */
+ (void)resumeDownloads;

/**
 Stop the current downlad and saves it back in the queue without triggering a new download.
 */
+ (void)pauseDownloads;

/**
 Creates an instance od DownloadSession
 
 @return Session - instance of self.
 */
+ (JSCSession *)session;

/**
 Adds a downloading task to the stack.
 
 @param URL - path to download.
 @param completionBlock - to be executed when the task finishes.
 */
+ (void)scheduleDownloadWithID:(NSString *)downloadID
                       fromURL:(NSURL *)url
                completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSURL *location, NSError *error))completionHandler;

/**
 Stops the current download and adds it to the stack, the it begins executing this new download.
 
 @param URL - path to download.
 @param completionBlock - to be executed when the task finishes.
 */
+ (void)forceDownloadWithID:(NSString *)downloadID
                    fromURL:(NSURL *)url
             completionBlock:(void (^)(JSCDownloadTaskInfo *downloadTask, NSURL *location, NSError *error))completionHandler;

/**
 Creates a download task to download the contents of the given URL.
 
 @param URL - path to download.
 */
- (NSURLSessionDownloadTask *)downloadTaskWithURL:(NSURL *)url;

/*
 * data task convenience methods.  These methods create tasks that
 * bypass the normal delegate calls for response and data delivery,
 * and provide a simple cancelable asynchronous interface to receiving
 * data.  Errors will be returned in the NSURLErrorDomain,
 * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
 * called for authentication challenges.
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

/**
 Delegate for the DownloadSessionDelegate class.
 */
@property (nonatomic, weak) id<JSCSessionDelegate>delegate;

@end
