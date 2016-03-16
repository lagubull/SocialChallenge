//
//  JSCOperationCoordinator.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCOperationCoordinator.h"

#import "JSCOperationScheduler.h"

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
 @param scheduler - Scheduler to coalesce the operation on.
 
 @return the coalesced operation
 */
- (JSCOperation *)coalesceOperation:(JSCOperation *)newOperation
                          scheduler:(id<JSCOperationScheduler>)scheduler;

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

#pragma mark - Schedulers

- (NSArray *)schedulers
{
    return [_mutableSchedulerTable allValues];
}

- (NSDictionary *)schedulerTable
{
    return [self.mutableSchedulerTable copy];
}

#pragma mark - Register

- (void)registerScheduler:(id<JSCOperationScheduler>)scheduler
      schedulerIdentifier:(NSString *)schedulerIdentifier
{
    self.mutableSchedulerTable[schedulerIdentifier] = scheduler;
}

#pragma mark - Add

- (void)addOperation:(JSCOperation *)operation
{
    id<JSCOperationScheduler> scheduler = self.mutableSchedulerTable[operation.targetSchedulerIdentifier];
    
    JSCOperation *coalescedOperation = [self coalesceOperation:operation
                                                     scheduler:scheduler];
    
    if (!coalescedOperation)
    {
        [scheduler addOperation:operation];
    }
}

#pragma mark - Coalescing

- (JSCOperation *)coalesceOperation:(JSCOperation *)newOperation
                          scheduler:(id<JSCOperationScheduler>)scheduler
{
    NSArray *operations = [scheduler operations];
    
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
