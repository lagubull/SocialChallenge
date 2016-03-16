//
//  JSCFeedRetrieveOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCFeedRetrieveOperation.h"

#import <CoredataServices/CDSServiceManager.h>

#import "JSCFeedRequest.h"
#import "JSCJSONManager.h"
#import "JSCPostPage.h"
#import "JSCPostPageParser.h"
#import "JSCSession.h"

@interface JSCFeedRetrieveOperation ()

/**
 Indicates the type of the request for data.
 */
@property (nonatomic, assign) JSCDataRetrievalOperationMode mode;

/**
 Task to retrieve the data.
 */
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation JSCFeedRetrieveOperation

@synthesize identifier = _identifier;

#pragma mark - Init

- (instancetype)initWithMode:(JSCDataRetrievalOperationMode)mode
{
    self = [super init];
    
    if (self)
    {
        self.mode = mode;
    }
    
    return self;
}

#pragma mark - Identifier

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [NSString stringWithFormat:@"retrieveFeed%@", @(self.mode)];
    }
    
    return _identifier;
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    JSCFeedRequest *request = [self requestForMode:self.mode];
    
    __weak typeof(self) weakSelf = self;
    
    self.task = [[JSCSession defaultSession] dataTaskWithRequest:request
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                 {
                     if (!error)
                     {
                         NSDictionary *feed = [JSCJSONManager processJSONData:data];
                         
                         JSCPostPageParser *pageParser = [JSCPostPageParser parserWithContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
                         
                         [[CDSServiceManager sharedInstance].backgroundManagedObjectContext performBlockAndWait:^
                          {
                              [pageParser parsePage:feed];
                          }];
                         
                         [weakSelf saveContextAndFinishWithResult:nil];
                     }
                     else
                     {
                         [weakSelf didFailWithError:error];
                     }
                 }];
    
    [self.task resume];
}

#pragma mark - Request

- (JSCFeedRequest *)requestForMode:(JSCDataRetrievalOperationMode)mode
{
    __block JSCFeedRequest *request = nil;
    
    switch (self.mode)
    {
        case JSCDataRetrievalOperationModeFirstPage:
        {
            request = [JSCFeedRequest requestToRetrieveFeed];
            
            break;
        }
        case JSCDataRetrievalOperationModeNextPage:
        {
            [[CDSServiceManager sharedInstance].backgroundManagedObjectContext performBlockAndWait:^
             {
                 JSCPostPage *page = [JSCPostPage fetchLastPageInContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
                 
                 request = [JSCFeedRequest requestToRetrieveFeedNexPageWithURL:page.nextPageRequestPath];
             }];
            
            break;
        }
    }
    
    return request;
}

#pragma mark - Cancel

- (void)cancel
{
    [super cancel];
    [self.task cancel];
    
    [self didSucceedWithResult:nil];
}

@end
