//
//  JSCPost.h
//  SocialChallenge
//
//  Created by Javier Laguna on 06/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JSCPostPage;
@class JSCUser;

NS_ASSUME_NONNULL_BEGIN

@interface JSCPost : NSManagedObject

/**
 Retrieves a JSCPOST from DB based on ID provided.
 
 @param postId - ID of the post to be retrieved.
 @param managedObjectContext - context that should be used to access persistent store.
 
 @return JSCPOST instance or nil if POST can't be found.
 */
+ (instancetype)fetchPostWithId:(NSString *)postId
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 Retrieves a JSCPOST from DB based on ID provided, looking in the mainContext.
 
 @param postId - ID of the post to be retrieved.
 
 @return JSCPOST instance or nil if POST can't be found.
 */
+ (instancetype)fetchPostWithId:(NSString *)postId;

/**
 Convenient method to shape the user's name into the desired format.
 */
- (NSString *)userName;

@end

NS_ASSUME_NONNULL_END

#import "JSCPost+CoreDataProperties.h"