//
//  JSCUser+CoreDataProperties.h
//  
//
//  Created by Javier Laguna on 01/02/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "JSCUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSCUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *avatarRemoteURL;

@end

NS_ASSUME_NONNULL_END
