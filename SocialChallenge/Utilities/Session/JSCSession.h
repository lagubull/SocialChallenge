//
//  JSCSession.h
//  SocialChallenge
//
//  Created by Javier Laguna on 26/02/2016.
//
//

#import <Foundation/Foundation.h>

/**
 Custom Session for API Calls
 */
@interface JSCSession : NSObject

+ (instancetype)defaultSession;

@property (nonatomic, strong) NSURLSession *session;

/*
 * data task convenience methods.  These methods create tasks that
 * bypass the normal delegate calls for response and data delivery,
 * and provide a simple cancelable asynchronous interface to receiving
 * data.  Errors will be returned in the NSURLErrorDomain,
 * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
 * called for authentication challenges.
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
