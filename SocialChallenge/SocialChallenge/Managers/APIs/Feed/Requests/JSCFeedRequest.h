//
//  JSCFeedRequest.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <Foundation/Foundation.h>

@interface JSCFeedRequest : NSMutableURLRequest

/**
 Creates a request for downloading a feed
 
 @return an instance of the class
 */
+ (instancetype)requestToRetrieveFeed;

@end
