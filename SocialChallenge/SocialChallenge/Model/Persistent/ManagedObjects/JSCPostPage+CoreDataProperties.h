//
//  JSCPostPage+CoreDataProperties.h
//  
//
//  Created by Javier Laguna on 01/02/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JSCPostPage.h"

@class JSCPost;

NS_ASSUME_NONNULL_BEGIN

@interface JSCPostPage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nextPageRequestPath;
@property (nullable, nonatomic, retain) NSString *postPageID;
@property (nullable, nonatomic, retain) JSCPost *post;

@end

NS_ASSUME_NONNULL_END
