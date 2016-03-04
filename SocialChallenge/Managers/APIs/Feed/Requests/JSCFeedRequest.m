//
//  JSCFeedRequest.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCFeedRequest.h"

/**
 HTTP GET Method.
 */
static NSString * const kJSCHTTPRequestMethodGet = @"GET";

@implementation JSCFeedRequest

#pragma mark - Retrieve

+ (instancetype)requestToRetrieveFeed
{
    JSCFeedRequest *request = [[self alloc] init];
    
    request.HTTPMethod = kJSCHTTPRequestMethodGet;
    
    request.URL = [NSURL URLWithString:API_END_POINT];
    
    return request;
}

+ (instancetype)requestToRetrieveFeedNexPageWithURL:(NSString *)URL
{
    JSCFeedRequest *request = [[self alloc] init];
    
    request.HTTPMethod = kJSCHTTPRequestMethodGet;
    
    request.URL = [NSURL URLWithString:URL];
    
    return request;
}

@end
