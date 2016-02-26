//
//  JSCSession.m
//  SocialChallenge
//
//  Created by Javier Laguna on 26/02/2016.
//
//

#import "JSCSession.h"

@interface JSCSessionTaskContext : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error);

@end

@implementation JSCSessionTaskContext

#pragma mark - ReceivedData

- (NSMutableData *)receivedData
{
    if (!_receivedData)
    {
        _receivedData = [[NSMutableData alloc] init];
    }
    
    return _receivedData;
}

@end

@interface JSCSession () <NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableDictionary *tasksContexts;

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
        
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:self
                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        _tasksContexts = [[NSMutableDictionary alloc] init];
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

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    
    JSCSessionTaskContext *context = [[JSCSessionTaskContext alloc] init];
    
    context.completionHandler = completionHandler;
    
    [self.tasksContexts setObject:context
                           forKey:@(task.taskIdentifier)];
    
    return task;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(NSURLSessionTask *)task
    didReceiveData:(NSData *)data
{
    JSCSessionTaskContext *context = [self.tasksContexts objectForKey:@(task.taskIdentifier)];
    [context.receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    JSCSessionTaskContext *context = [self.tasksContexts objectForKey:@(task.taskIdentifier)];
    
    if (context.completionHandler)
    {
        context.completionHandler(context.receivedData, task.response, error);
    }
}

@end
