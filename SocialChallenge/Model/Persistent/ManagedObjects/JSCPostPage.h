//
//  JSCPostPage.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCPostPage : NSManagedObject

/**
 Retrieves the last page of posts stored in the context.
 
 @param context in which we want to perform the search.
 
 @return JSCPostPage - instace of the JSCPostPage class
 */
+ (JSCPostPage *)fetchLastPageInContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "JSCPostPage+CoreDataProperties.h"
