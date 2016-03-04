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

NS_ASSUME_NONNULL_BEGIN

@interface JSCPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSString *postId;
@property (nullable, nonatomic, retain) JSCPostPage *page;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *userFirstName;
@property (nullable, nonatomic, retain) NSString *userLastName;
@property (nullable, nonatomic, retain) NSString *userAvatarRemoteURL;

@end

NS_ASSUME_NONNULL_END
