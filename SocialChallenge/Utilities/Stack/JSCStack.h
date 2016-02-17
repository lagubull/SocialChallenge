//
//  JSCStack.h
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import <Foundation/Foundation.h>

@interface JSCStack : NSObject

/**
 Number of items in the stack.
 */
@property (nonatomic, assign, readonly) NSInteger count;

/**
 Items in the stack.
 */
@property (nonatomic, strong, readonly) NSMutableArray* objectsArray;

/**
 Inserts in the stack.
 
 @param anObject - object to insert.
 */
- (void)push:(id)anObject;

/**
 Retrieves from the stack.
 
 @return anObject - object to extracted.
 */
- (id)pop;

/**
 Empties the stack.
 */
- (void)clear;

@end
