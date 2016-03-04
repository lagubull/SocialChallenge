//
//  JSCFeedRetrieveOperationTests.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/03/2016.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "JSCFeedRetrieveOperation.h"

#import "JSCFeedRequest.h"
#import "JSCJSONManager.h"
#import "JSCPostPageParser.h"
#import "CDSServiceManager.h"
#import "JSCSession.h"


@interface JSCFeedRetrieveOperation ()

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@interface JSCFeedRetrieveOperationTests : XCTestCase

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) JSCFeedRetrieveOperation *operation;

@property (nonatomic, strong) id operationMock;

@property (nonatomic, strong) id sessionMock;

@property (nonatomic, strong) id coredataServiceManagerMock;

@property (nonatomic, strong) id contextMock;

@property (nonatomic, strong) JSCSession *session;

@property (nonatomic, strong) id taskMock;

@property (nonatomic, strong) id  parserMock;

@property (nonatomic, strong) id bundleMock;

@property (nonatomic, strong) NSError *error;

@end

@implementation JSCFeedRetrieveOperationTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    self.bundleMock = [OCMockObject mockForClass:[NSBundle class]];
    [[[self.bundleMock stub] andReturn:[NSBundle bundleForClass:[self class]]] mainBundle];
    
    [[CDSServiceManager sharedInstance] setupModelURLWithModelName:@"SocialChallenge"];

    self.session = [self setSession];
    self.sessionMock = OCMClassMock([JSCSession class]);
    
    self.operation = [[JSCFeedRetrieveOperation alloc] initWithMode:JSCDataRetrievalOperationModeFirstPage];
    self.operationMock = OCMPartialMock(self.operation);
    
    self.taskMock = OCMClassMock([NSURLSessionDataTask class]);
    
    self.parserMock = OCMClassMock([JSCPostPageParser class]);
    
    self.queue = [NSOperationQueue mainQueue];
    self.queue.maxConcurrentOperationCount = 1;
    
    self.error = [[NSError alloc] init];
}

- (void)tearDown
{
    [[CDSServiceManager sharedInstance] clear];
    
    self.queue = nil;
    
    self.operation = nil;
    self.operationMock = nil;
    
    self.sessionMock = nil;
    self.taskMock = nil;
    
    self.error = nil;
    
    [super tearDown];
}

#pragma mark - Session

- (JSCSession *)setSession
{
    if (!_session)
    {
        _session = [JSCSession defaultSession];
    }
    
    return _session;
}

#pragma mark - WaitForOperation

- (void)waitForOperation
{
    [self.queue addOperation:self.operation];
    
    [self waitForExpectationsWithTimeout:1.0
                                 handler:^(NSError *error)
     {
         [self.operation finish];
     }];
}

#pragma mark - Request

- (void)test_Request_firstPage_ShouldBeCreated
{
    id requestMock = OCMClassMock([JSCFeedRequest class]);
    
    [OCMStub(ClassMethod([ self.sessionMock defaultSession])) andReturn: self.sessionMock];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request for first page should be created."];
    
    [OCMStub(ClassMethod([requestMock requestToRetrieveFeed])) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

- (void)test_Request_otherPage_ShouldBeCreated
{
    self.operation = [[JSCFeedRetrieveOperation alloc] initWithMode:JSCDataRetrievalOperationModeNextPage];
    self.operationMock = OCMPartialMock(self.operation);
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    id requestMock = OCMClassMock([JSCFeedRequest class]);
    
    id postPageMock = OCMClassMock([JSCPostPage class]);
    
    OCMStub(ClassMethod([postPageMock fetchLastPageInContext:[OCMArg any]]));
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request for other than the first page should be created."];
    
    [OCMStub(ClassMethod([requestMock requestToRetrieveFeedNexPageWithURL:[OCMArg any]])) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

#pragma mark - Task

- (void)test_Task_ShouldBeCreated
{
    [[self.operationMock expect] setTask:[OCMArg isKindOfClass:[NSURLSessionDataTask class]]];

    [self.operation start];

    [self.operationMock verify];
}

#pragma mark - Cancel

- (void)test_Cancel_TaskShouldBeCancelled
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Task should be cancelled."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andReturn:self.taskMock];
    
    [OCMStub([self.taskMock resume]) andDo:^(NSInvocation *invocation)
     {
         [self.operation cancel];
     }];
    
    [OCMStub([self.taskMock cancel]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

- (void)test_Cancel_ShouldCallDidSucceedWithResult
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should complete with success."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andReturn:self.taskMock];
    
    [OCMStub([self.taskMock resume]) andDo:^(NSInvocation *invocation)
     {
         [self.operation cancel];
     }];
    
    [OCMStub([self.operationMock didSucceedWithResult:nil]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

#pragma mark - NetworkError

- (void)test_NetworkError_ShouldCallFailWithError
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should call didFailWithError on Network error."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation)
    {
        void(^usingBlockStubResponse)(NSData *data, NSURLResponse *response, NSError *error);
        
        [invocation getArgument:&usingBlockStubResponse
                        atIndex:3];
        
        usingBlockStubResponse(nil, nil, self.error);
        
    }];
    
    [OCMStub([self.operationMock didFailWithError:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

- (void)test_NetworkError_ShouldCallFailWithErrorWithErrorObject
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should pass error object to didFailWithError on Network error."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         void(^usingBlockStubResponse)(NSData *data, NSURLResponse *response, NSError *error);
         
         [invocation getArgument:&usingBlockStubResponse
                         atIndex:3];
         
         usingBlockStubResponse(nil, nil, self.error);
         
     }];
    
    [OCMStub([self.operationMock didFailWithError:self.error]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

#pragma mark - NetworkSuccess

- (void)test_NetworkSuccess_ShouldSetParserManagedContext
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should set parser managed context."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         void(^usingBlockStubResponse)(NSData *data, NSURLResponse *response, NSError *error);
         
         [invocation getArgument:&usingBlockStubResponse
                         atIndex:3];
         
         usingBlockStubResponse(nil, nil, nil);
         
     }];
    
    [OCMStub([self.parserMock parserWithContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

- (void)test_NetworkSuccess_ShouldParseResponse
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should parse response."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         void(^usingBlockStubResponse)(NSData *data, NSURLResponse *response, NSError *error);
         
         [invocation getArgument:&usingBlockStubResponse
                         atIndex:3];
         
         usingBlockStubResponse(nil, nil, nil);
         
     }];
    
    [OCMStub([self.parserMock parserWithContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext]) andReturn:self.parserMock];
    
    [OCMStub([self.parserMock parsePage:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

#pragma mark - ParseComplete

- (void)test_NetworkSuccess_ShouldCallSaveContextOnParseComplete
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Operation should call SaveContext on parse complete."];
    
    [OCMStub(ClassMethod([self.sessionMock defaultSession])) andReturn:self.sessionMock];
    
    [OCMStub([self.sessionMock dataTaskWithRequest:[OCMArg any]
                                 completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         void(^usingBlockStubResponse)(NSData *data, NSURLResponse *response, NSError *error);
         
         [invocation getArgument:&usingBlockStubResponse
                         atIndex:3];
         
         usingBlockStubResponse(nil, nil, nil);
         
     }];
    
    [OCMStub([self.parserMock parserWithContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext]) andReturn:self.parserMock];
    
    [OCMStub([self.operationMock saveContextAndFinishWithResult:[OCMArg any]]) andDo:^(NSInvocation *invocation)
     {
         [expectation fulfill];
     }];
    
    [self waitForOperation];
}

@end
