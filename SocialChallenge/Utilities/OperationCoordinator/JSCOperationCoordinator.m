//
//  JSCOperationCoordinator.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCOperationCoordinator.h"

#import "JSCOperation.h"

NSString * const kJSCNetworkDataOperationSchedulerTypeIdentifier = @"kJSCNetworkDataOperationSchedulerTypeIdentifier";

NSString * const kJSCLocalDataOperationSchedulerTypeIdentifier = @"kJSCLocalDataOperationSchedulerTypeIdentifier";

@interface JSCOperationCoordinator ()

/**
 Contains the schedulers in the app.
 */
@property (nonatomic, strong) NSMutableDictionary *mutableSchedulerTable;

/**
 Finds the first operation which can coalesce the passed in operation
 and coalesce with it.
 
 @param operation - opearation to coaleque with.
 @param queue - queue to coalesce the operation on.
 
 @return the coalesced operation
 */
- (JSCOperation *)coalesceOperation:(JSCOperation *)newOperation
                              queue:(NSOperationQueue *)queue;

@end

@implementation JSCOperationCoordinator

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static JSCOperationCoordinator *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[JSCOperationCoordinator alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.mutableSchedulerTable = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Register

- (void)registerQueue:(NSOperationQueue *)queue
  schedulerIdentifier:(NSString *)schedulerIdentifier
{
    self.mutableSchedulerTable[schedulerIdentifier] = queue;
}

#pragma mark - Add

- (void)addOperation:(JSCOperation *)operation
{
    NSOperationQueue *queue = self.mutableSchedulerTable[operation.targetSchedulerIdentifier];
    
    JSCOperation *coalescedOperation = [self coalesceOperation:operation
                                                         queue:queue];
    
    if (!coalescedOperation)
    {
        [queue addOperation:operation];
    }
}

#pragma mark - Coalescing

- (JSCOperation *)coalesceOperation:(JSCOperation *)newOperation
                              queue:(NSOperationQueue *)queue
{
    NSArray *operations = [queue operations];
    
    for (JSCOperation *operation in operations)
    {
        BOOL canAskToCoalesce = [operation isKindOfClass:[JSCOperation class]];
        
        if (canAskToCoalesce &&
            [operation canCoalesceWithOperation:newOperation])
        {
            [operation coalesceWithOperation:newOperation];
            return operation;
        }
    }
    
    return nil;
}

@end
