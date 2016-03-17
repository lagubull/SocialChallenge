//
//  JSCOperationCoordinator.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

/**
 Identifier for network based operations.
 */
extern NSString * const kJSCNetworkDataOperationSchedulerTypeIdentifier;

/**
 Identifier for local operations.
 */
extern NSString * const kJSCLocalDataOperationSchedulerTypeIdentifier;

@class JSCOperation;

/**
 This class handles the schedulers that run the operations.
 */
@interface JSCOperationCoordinator : NSObject

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
 
 @param queue - queue to register with the coordinator.
 @param schedulerIdentifier - scheduler identifier to register the coordinator under.
 */
- (void)registerQueue:(NSOperationQueue *)queue
  schedulerIdentifier:(NSString *)schedulerIdentifier;

@end