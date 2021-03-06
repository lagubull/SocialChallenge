//
//  JSCLocalImageAssetRetrievalOperation.h
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCOperation.h"

@interface JSCLocalImageAssetRetrievalOperation : JSCOperation

/**
 Creates an operation to retrieve an asset from disk.
 
 @param postId - indicates the post the asset is related to.
 
 @return an instance of the class.
 */
- (instancetype)initWithPostId:(NSString *)postId;

@end
