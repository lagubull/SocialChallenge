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
 Creates a request for downloading the feed first page.
 
 @return an instance of the class.
 */
+ (instancetype)requestToRetrieveFeed;

/**
 Creates a request for downloading a page of content.
 
 @param URL - URL to download the content from.
 
 @return an instance of the class.
 */
+ (instancetype)requestToRetrieveFeedNexPageWithURL:(NSString *)URL;

@end
