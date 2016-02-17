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

@implementation JSCMediaManager

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
                
                [JSCSession scheduleDownloadFromURL:[NSURL URLWithString:post.userAvatarRemoteURL]
                                    completionBlock:^(JSCDownloadTaskInfo *downloadTask, NSURL *location, NSError *error)
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
                        JSCMediaStorageOperation *storageOperation = [[JSCMediaStorageOperation alloc] initWithPostID:post.postID
                                                                                                             location:location];
                        
                        storageOperation.onSuccess = success;
                        storageOperation.onFailure = failure;
                    }
                }];
            }
        };
    }
}

@end
