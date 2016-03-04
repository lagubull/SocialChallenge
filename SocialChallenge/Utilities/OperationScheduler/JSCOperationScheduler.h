//
//  JSCOperationScheduler.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

@class NSOperation;

/**
 Classes adopting the `JSCOperationScheduler` can be used
 to schedule operations by the JSCOperationCoordinator.
 
 NSOperationQueue is already compliant to this protocol.
 */
@protocol JSCOperationScheduler <NSObject>

/**
 Indicates whether the scheduler is executing.
 */
@property (nonatomic, assign, getter=isSuspended) BOOL suspended;

/**
 Contains the operations waiting to execute.
 */
@property (readonly, copy) NSArray *operations;

/**
 Inserts an operation in the queue
 
 @param operation to add
 */
- (void)addOperation:(NSOperation *)operation;

/**
 Stops all operations in the queue
 */
- (void)cancelAllOperations;

@end