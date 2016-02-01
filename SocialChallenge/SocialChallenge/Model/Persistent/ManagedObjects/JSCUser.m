//
//  JSCUser.m
//  
//
//  Created by Javier Laguna on 01/02/2016.
//
//

#import "JSCUser.h"

#import "JSCPost.h"
#import "CDSServiceManager.h"
#import "NSManagedObjectContext+CDSRetrieval.h"

@implementation JSCUser

#pragma mark - User

+ (instancetype)fetchUserWithID:(NSString *)userID
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID MATCHES %@", userID];
    
    return (JSCUser *)[managedObjectContext cds_retrieveFirstEntryForEntityClass:[JSCUser class]
                                                                       predicate:predicate];
}

+ (instancetype)fetchUserWithID:(NSString *)userID
{
    return [JSCUser fetchUserWithID:userID
               managedObjectContext:[CDSServiceManager sharedInstance].mainManagedObjectContext];
}

@end
