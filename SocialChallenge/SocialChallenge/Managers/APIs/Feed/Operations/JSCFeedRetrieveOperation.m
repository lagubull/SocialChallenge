//
//  JSCFeedRetrieveOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCFeedRetrieveOperation.h"

#import "JSCFeedRequest.h"
#import "JSCSession.h"
#import "JSCJSONManager.h"
#import "JSCPostPage.h"
#import "JSCPostPageParser.h"
#import "CDSServiceManager.h"

@interface JSCFeedRetrieveOperation ()

@property (nonatomic, assign) JSCDataRetrievalOperationMode mode;

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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        self.mode = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(mode))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.mode
                    forKey:NSStringFromSelector(@selector(mode))];
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    JSCFeedRequest *request = [self requestForMode:self.mode];
    
    __weak typeof(self) weakSelf = self;
    
    self.task = [[JSCSession session] dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                 {
                     if (!error)
                     {
                         NSDictionary *feed = [JSCJSONManager processJSONData:data];
                         
                         JSCPostPageParser *pageParser = [JSCPostPageParser parser];
                         
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

@end
