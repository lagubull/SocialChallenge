//
//  JSCMediaManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCMediaManager.h"

#import <EDSDownloadSession.h>

#import "JSCPost.h"
#import "JSCLocalImageAssetRetrievalOperation.h"
#import "JSCMediaStorageOperation.h"
#import "JSCOperationCoordinator.h"
#import "JSCFileManager.h"

@implementation JSCMediaManager

#pragma mark - Retrieval

+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(JSCPost *post))retrievalRequired
                     success:(void (^)(id result, NSString *postId))success
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
                    success(imageMedia, post.postID);
                }
            }
            else
            {
                if (retrievalRequired)
                {
                    retrievalRequired(post);
                }
                
                [EDSDownloadSession scheduleDownloadWithID:post.postID
                                                   fromURL:[NSURL URLWithString:post.userAvatarRemoteURL]
                                                  progress:nil
                                                   success:^(EDSDownloadTaskInfo *downloadTask, NSData *responseData, NSURL *location)
                 {
                     JSCMediaStorageOperation *op = [[JSCMediaStorageOperation alloc] initWithPostID:post.postID
                                                                                                data:responseData];
                     
                     op.onSuccess = ^(id result)
                     {
                         if (success)
                         {
                             success(result, post.postID);
                         }
                     };
                     
                     op.onFailure = failure;
                     
                     op.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
                     
                     [[JSCOperationCoordinator sharedInstance] addOperation:op];
                 }
                                                   failure:^(EDSDownloadTaskInfo *downloadTask, NSError *error)
                 {
                     if (failure)
                     {
                         failure(error);
                     }
                 }];
            }
        };
        
        operation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
        
        [[JSCOperationCoordinator sharedInstance] addOperation:operation];
    }
}

@end
