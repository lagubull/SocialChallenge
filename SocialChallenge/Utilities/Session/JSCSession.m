//
//  JSCSession.m
//  SocialChallenge
//
//  Created by Javier Laguna on 26/02/2016.
//
//

#import "JSCSession.h"

@interface JSCSession ()

@end

@implementation JSCSession

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [configuration setHTTPMaximumConnectionsPerHost:10];
        
        self = (JSCSession *)[NSURLSession sessionWithConfiguration:configuration
                                                           delegate:nil
                                                      delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return self;
}

#pragma mark - Session

+ (instancetype)defaultSession
{
    static JSCSession *defaultSession = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        defaultSession = [[self alloc] init];
    });
    
    return defaultSession;
}

@end
