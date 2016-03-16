//
//  JSCMediaManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCMediaManager.h"

#import <EasyDownloadSession/EDSDownloadSession.h>

#import "JSCOperationCoordinator.h"
#import "JSCFileManager.h"

@implementation JSCMediaManager

#pragma mark - Retrieval

+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(NSString *postId))retrievalRequired
                     success:(void (^)(id result, NSString *postId))success
                     failure:(void (^)(NSError *error, NSString *postId))failure;
{
    if (post.userAvatarRemoteURL)
    {
        JSCLocalImageAssetRetrievalOperation *operation = [[JSCLocalImageAssetRetrievalOperation alloc] initWithPostId:post.postId];
        
        operation.onCompletion = ^(UIImage *imageMedia)
        {
            if (imageMedia)
            {
                if (success)
                {
                    success(imageMedia, post.postId);
                }
            }
            else
            {
                if (retrievalRequired)
                {
                    retrievalRequired(post.postId);
                }
                
                [EDSDownloadSession scheduleDownloadWithId:post.postId
                                                   fromURL:[NSURL URLWithString:post.userAvatarRemoteURL]
                                                  progress:nil
                                                   success:^(EDSDownloadTaskInfo *downloadTask, NSData *responseData)
                 {
                     JSCMediaStorageOperation *storeOPeration = [[JSCMediaStorageOperation alloc] initWithPostId:post.postId
                                                                                                            data:responseData];
                     
                     storeOPeration.onSuccess = ^(id result)
                     {
                         if (result)
                         {
                             if (success)
                             {
                                 success(result, post.postId);
                             }
                         }
                         else
                         {
                             if (failure)
                             {
                                 failure(nil, post.postId);
                             }
                         }
                     };

                     storeOPeration.onFailure = ^(NSError *error)
                     {
                         if (failure)
                         {
                             failure(error, post.postId);
                         }
                     };
                     
                     storeOPeration.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
                     
                     [[JSCOperationCoordinator sharedInstance] addOperation:storeOPeration];
                 }
                                                   failure:^(EDSDownloadTaskInfo *downloadTask, NSError *error)
                 {
                     if (failure)
                     {
                         failure(error, post.postId);
                     }
                 }];
            }
        };

        operation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
        
        [[JSCOperationCoordinator sharedInstance] addOperation:operation];
    }
    else
    {
        if (failure)
        {
            failure(nil, post.postId);
        }
    }
}

@end
