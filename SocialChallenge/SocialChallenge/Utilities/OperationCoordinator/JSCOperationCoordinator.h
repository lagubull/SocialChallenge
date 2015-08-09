//
//  JSCOperationCoordinator.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

extern NSString * const kJSCNetworkDataOperationSchedulerTypeIdentifier;

#import "JSCOperationScheduler.h"

@class JSCOperation;

@interface JSCOperationCoordinator : NSObject

@property (nonatomic, strong, readonly) NSDictionary *schedulerTable;

@property (nonatomic, strong, readonly) NSArray *schedulers;


/**
 Creates or returns an instance of the class
 
 @return instance of the class
 */
+ (instancetype)sharedInstance;

/**
 Adds operation to the scheduler, if an operation
 with the same identifier is on the scheduler then the coordinator
 will perform coalescing.
 
 @param operation - operation to add.
 */
- (void)addOperation:(JSCOperation *)operation;

/**
 Registers a Scheduler with the coordinator.
 
 @param scheduler           Scheduler to register with the coordinator.
 @param schedulerIdentifier Scheduler identifier to register the coordinator under.
 */
- (void)registerScheduler:(id<JSCOperationScheduler>)scheduler
schedulerIdentifier:(NSString *)schedulerIdentifier;

@end