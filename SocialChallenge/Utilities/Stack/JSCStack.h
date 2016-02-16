//
//  JSCStack.h
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import <Foundation/Foundation.h>

@interface JSCStack : NSObject

@property (nonatomic, assign, readonly) NSInteger count;

- (void)push:(id)anObject;

- (id)pop;

- (void)clear;

@end
