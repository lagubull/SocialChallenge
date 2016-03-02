//
//  JSCMediaStorageOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import "JSCOperation.h"

@interface JSCMediaStorageOperation : JSCOperation

/**
 Creates an operation to store an asset.
 
 @param postId - indicates the post the asset is related to.
 @param location - indicates where the object has been stored by default.
 
 @return an instance of the class.
 */
- (instancetype)initWithPostID:(NSString *)postId
                      data:(NSData *)data;

@end
