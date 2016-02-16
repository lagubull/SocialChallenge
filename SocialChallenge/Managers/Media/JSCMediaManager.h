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

+ (void)retrieveMediaForPost:(JSCPost *)post
           retrievalRequired:(void (^)(JSCPost *post))retrievalRequired
                     Success:(JSCOperationOnSuccessCallback)success
                     failure:(JSCOperationOnFailureCallback)failure;

@end
