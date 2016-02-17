//
//  JSCMediaManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCMediaManager.h"

#import "JSCPost.h"
#import "JSCLocalImageAssetRetrievalOperation.h"
#import "JSCSession.h"
#import "JSCMediaStorageOperation.h"
#import "JSCOperationCoordinator.h"
#import "JSCFileManager.h"

@implementation JSCMediaManager

#pragma mark - Retrieval

+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(JSCPost *post))retrievalRequired
                     Success:(JSCOperationOnSuccessCallback)success
                     failure:(JSCOperationOnFailureCallback)failure
{
    if (post.userAvatarRemoteURL)
    {
        JSCLocalImageAssetRetrievalOperation *operation = [[JSCLocalImageAssetRetrievalOperation alloc] initWithPostID:post.postID];
        
        operation.onCompletion = ^(UIImage *imageMedia)
        {
            if (imageMedia)
            {
                if (success)
                {
                    success(imageMedia);
                }
            }
            else
            {
                if (retrievalRequired)
                {
                    retrievalRequired(post);
                }
                
                [JSCSession forceDownloadWithID:post.postID
                                        fromURL:[NSURL URLWithString:post.userAvatarRemoteURL]
                                completionBlock:^(JSCDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location, NSError *error)
                 {
                     if (error)
                     {
                         if (failure)
                         {
                             failure(error);
                         }
                     }
                     else
                     {
                         
                         JSCMediaStorageOperation *op = [[JSCMediaStorageOperation alloc] initWithPostID:post.postID
                                                                                                    data:responseData];
                         
                         op.onSuccess = success;
                         op.onFailure = failure;
                         
                         op.targetSchedulerIdentifier = kJSCNetworkDataOperationSchedulerTypeIdentifier;
                         
                         [[JSCOperationCoordinator sharedInstance] addOperation:op];
                     }
                     
                 }];
            }
        };
        
        operation.targetSchedulerIdentifier = kJSCNetworkDataOperationSchedulerTypeIdentifier;
        
        [[JSCOperationCoordinator sharedInstance] addOperation:operation];
    }
}

@end
