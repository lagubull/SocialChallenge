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

@implementation JSCMediaManager

+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(JSCPost *post))retrievalRequired
                     Success:(JSCOperationOnSuccessCallback)success
                     failure:(JSCOperationOnFailureCallback)failure
{
    if (post.userAvatarRemoteURL)
    {
        JSCLocalImageAssetRetrievalOperation *operation = [[JSCLocalImageAssetRetrievalOperation alloc] init];
        
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
                
                //ScheduleTask
                //crear task success
                //crear task failure
            }
        };
    }
}

@end
