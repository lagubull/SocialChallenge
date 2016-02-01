//
//  JSCUser.h
//  
//
//  Created by Javier Laguna on 01/02/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JSCPost;

NS_ASSUME_NONNULL_BEGIN

@interface JSCUser : NSManagedObject

/**
 Retrieves a JSCUSER from DB based on ID provided.
 
 @param userID - ID of the user to be retrieved.
 @param managedObjectContext - context that should be used to access persistent store.
 
 @return JSCUSER instance or nil if USER can't be found.
 */
+ (instancetype)fetchUserWithID:(NSString *)userID
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/**
 Retrieves a JSCUSER from DB based on ID provided, looking in the mainContext.
 
 @param userID - ID of the user to be retrieved.
 
 @return JSCUSER instance or nil if USER can't be found.
 */
+ (instancetype)fetchUserWithID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END

#import "JSCUser+CoreDataProperties.h"
