//
//  JSCPost.h
//  SocialChallenge
//
//  Created by Javier Laguna on 06/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCPost : NSManagedObject

/**
 Retrieves a JSCPOST from DB based on ID provided.
 
 @param postID - ID of the post to be retrieved.
 @param managedObjectContext - context that should be used to access persistent store.
 
 @return JSCPOST instance or nil if POST can't be found.
 */
+ (instancetype)fetchPostWithID:(NSString *)postID
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 Retrieves a JSCPOST from DB based on ID provided, looking in the mainContext.
 
 @param postID - ID of the post to be retrieved.
 
 @return JSCPOST instance or nil if POST can't be found.
 */
+ (instancetype)fetchPostWithID:(NSString *)postID;

@end

NS_ASSUME_NONNULL_END

#import "JSCPost+CoreDataProperties.h"