//
//  JSCOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <Foundation/Foundation.h>

/**
 Success block type.
 */
typedef void (^JSCOperationOnSuccessCallback)(id result);

/**
 Completion block type.
 */
typedef void (^JSCOperationOnCompletionCallback)(id result);

/**
 Failure block type.
 */
typedef void (^JSCOperationOnFailureCallback)(NSError *error);

/**
 Code base for the operations in the app.
 */
@interface JSCOperation : NSOperation

/**
 Identifies the operation.
 */
@property (atomic, copy) NSString *identifier;

/**
 Identifies the scheduler for the operation.
 */
@property (atomic, copy) NSString *targetSchedulerIdentifier;

/**
 Callback called when the operation completes successfully.
 */
@property (nonatomic, copy) JSCOperationOnSuccessCallback onSuccess;

/**
 Callback called when the operation completes with an error.
 */
@property (nonatomic, copy) JSCOperationOnFailureCallback onFailure;

/**
 Callback called when the operation completes.
 
 The completion block is used instead of the success/failure blocks not alongside.
 */
@property (nonatomic, copy) JSCOperationOnCompletionCallback onCompletion;

/**
 The result of the operation.
 */
@property (nonatomic, strong, readonly) id result;

/**
 The error of the operation.
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 Progress object used to indicate the progress of the operation.
 */
@property (nonatomic, strong, readonly) NSProgress *progress;

/**
 Finishes the execution of the operation.
  */
- (void)finish;

/**
 Finishes the execution of the operation and calls the onSuccess callback.
 */
- (void)didSucceedWithResult:(id)result;

/**
 Finishes the execution of the operation and calls the onFailure callback.
 */
- (void)didFailWithError:(NSError *)error;

/**
 Finishes the execution of the operation and calls the onCompletion callback.
 */
- (void)didCompleteWithResult:(id)result;

/**
 This method figures out if we can coalesce with another operation.
 
 @param operation - Operation to determaine if we can coalesce with.
 
 @return YES if we can coaslesce with it, NO if not.
  */
- (BOOL)canCoalesceWithOperation:(JSCOperation *)operation;

/**
 This method coalesces another operation with this one, so that it
 is all performed in one operation.
 
 Perform any logic here to merge the actions together.
 
 @param operation - Operation to coalesce with.
 */
- (void)coalesceWithOperation:(JSCOperation *)operation;

@end
