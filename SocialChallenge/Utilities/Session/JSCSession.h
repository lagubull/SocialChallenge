//
//  JSCSession.h
//  SocialChallenge
//
//  Created by Javier Laguna on 26/02/2016.
//
//

#import <Foundation/Foundation.h>

/**
 Custom Session for API Calls.
 */
@interface JSCSession : NSURLSession

/**
 Session to be used when contacting the API Server.
 */
+ (instancetype)defaultSession;

@end
