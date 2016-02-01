//
//  JSCPost+CoreDataProperties.h
//  
//
//  Created by Javier Laguna on 01/02/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JSCPost.h"

@class JSCPostPage;
@class JSCUser;

NS_ASSUME_NONNULL_BEGIN

@interface JSCPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSNumber *like_count;
@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) JSCPostPage *page;
@property (nullable, nonatomic, retain) JSCUser *user;
@property (nullable, nonatomic, retain) NSString *content;

@end

NS_ASSUME_NONNULL_END
