//
//  JSCUserParser.m
//  SocialChallenge
//
//  Created by Javier Laguna on 01/02/2016.
//
//

#import "JSCUserParser.h"

#import "JSCUser.h"
#import "CDSServiceManager.h"

@implementation JSCUserParser

#pragma mark - User

- (JSCUser *)parseUser:(NSDictionary *)userDictionary
{
    JSCUser *user = nil;
    
    if (userDictionary[@"id"])
    {
        user = [JSCUser fetchUserWithID:userDictionary[@"id"]
                   managedObjectContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
        
        if (!user)
        {
            user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JSCUser class])
                                                 inManagedObjectContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
        }
        
        user.avatarRemoteURL = JSCValueOrDefault(userDictionary[@"avatar"], user.avatarRemoteURL);
        user.firstName = JSCValueOrDefault(userDictionary[@"first_name"], user.firstName);
        user.lastName = JSCValueOrDefault(userDictionary[@"last_name"], user.lastName);
    }
    
    return user;
}

@end
