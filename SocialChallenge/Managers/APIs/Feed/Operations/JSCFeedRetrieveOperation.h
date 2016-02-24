//
//  JSCFeedRetrieveOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCCDSOperation.h"

@interface JSCFeedRetrieveOperation : JSCCDSOperation

/**
 Creates an operation to retrieve a feed.
 
 @param mode indicates whether should be the first the page or second.
 
 @return an instance of the class.
 */
- (instancetype)initWithMode:(JSCDataRetrievalOperationMode)mode;

@end
