//
//  JSCFeedRequest.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCFeedRequest.h"

static NSString * const kJSCFeedURL = @"http://unii-interview.herokuapp.com/api/v1/posts";
static NSString * const kJSCHTTPRequestMethodGet = @"GET";

@implementation JSCFeedRequest

+ (instancetype)requestToRetrieveFeed
{
    JSCFeedRequest *request = [[self alloc] init];
    
    request.HTTPMethod = kJSCHTTPRequestMethodGet;
    
    request.URL = [NSURL URLWithString:kJSCFeedURL];
    
    return request;
}

@end
