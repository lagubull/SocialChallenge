//
//  JSCPost.m
//  SocialChallenge
//
//  Created by Javier Laguna on 06/08/2015.
//
//

#import "JSCPost.h"

#import "CDSServiceManager.h"
#import "NSManagedObjectContext+CDSRetrieval.h"

@implementation JSCPost

#pragma mark - Post

+ (instancetype)fetchPostWithId:(NSString *)postId
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postId MATCHES %@", postId];
    
    return (JSCPost *)[managedObjectContext cds_retrieveFirstEntryForEntityClass:[JSCPost class]
                                                                       predicate:predicate];
}

+ (instancetype)fetchPostWithId:(NSString *)postId
{
    return [JSCPost fetchPostWithId:postId
               managedObjectContext:[CDSServiceManager sharedInstance].mainManagedObjectContext];
}

#pragma mark - UserName

- (NSString *)userName
{
    return [NSString stringWithFormat:@"%@ %@.", self.userFirstName, [self.userLastName substringWithRange:NSMakeRange(0,
                                                                                                               1)]];
}

@end
