//
//  JSCOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <Foundation/Foundation.h>

typedef void (^JSCOperationOnSuccessCallback)(id result);

typedef void (^JSCOperationOnFailureCallback)(NSError *error);

@interface JSCOperation : NSOperation <NSCoding, NSCopying>

@property (atomic, copy) NSString *identifier;

@property (atomic, copy) NSString *targetSchedulerIdentifier;

@property (nonatomic, copy) JSCOperationOnSuccessCallback onSuccess;

@property (nonatomic, copy) JSCOperationOnFailureCallback onFailure;

@property (nonatomic, strong, readonly) id result;

@property (nonatomic, strong, readonly) NSError *error;

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
 This method figures out if we can coalesce with another operation.
 
 @param operation - Operation to determaine if we can coalesce with.
 
 @return YES if we can coaslesce with it, NO if not.
  */
- (BOOL)canCoalesceWithOperation:(JSCOperation *)operation;

/**
 This method coalesces another operation with this one, so that it
 is all performed in one operation.
 
 Perform any logic here to merge the actions together.
 
 i.e For a unblock / block pair you could cancel the work.
 
 @param operation - Operation to coalesce with.
 */
- (void)coalesceWithOperation:(JSCOperation *)operation;

@end
