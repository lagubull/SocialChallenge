//
//  JSCFeedAPIManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <Foundation/Foundation.h>

@interface JSCFeedAPIManager : NSObject

/**
 Cretes and queues an operation for retrieving the feed
 
 @param mode first page or a next page
 @param success callback if the request is successful
 @param failture callback if the request fails
 */
+ (void)retrieveFeedWithMode:(JSCDataRetrievalOperationMode)mode
                     Success:(JSCOperationOnSuccessCallback)success
                     failure:(JSCOperationOnFailureCallback)failure;

@end
