//
//  JSCMediaManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import <Foundation/Foundation.h>

#import "JSCCDSOperation.h"

@class JSCPost;

@interface JSCMediaManager : NSObject

/**
 Retrieves a media for a post.
 
 @param post - post which we want media for.
 @param retrievalRequired - block to execute while a download is in progress.
 @param succes - block to execute in case of success.
 @parama failure - block to execute on failure.
 */
+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(NSString *postId))retrievalRequired
                     success:(void (^)(id result, NSString *postId))success
                     failure:(void (^)(NSError *error, NSString *postId))failure;

@end
