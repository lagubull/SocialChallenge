//
//  JSCCDSOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCOperation.h"

@interface JSCCDSOperation : JSCOperation

/**
 Saves the local managed object context and finishes the execution of the operation.
 
 @param result - result to finish with and pass to on success callback.
 */
- (void)saveContextAndFinishWithResult:(id)result;

@end
