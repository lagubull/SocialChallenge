//
//  JSCPost+CoreDataProperties.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JSCPost.h"

@class JSCPostPage;

NS_ASSUME_NONNULL_BEGIN

@interface JSCPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) JSCPostPage *page;

@end

NS_ASSUME_NONNULL_END
