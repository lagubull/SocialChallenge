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

+ (instancetype)fetchPostWithID:(NSString *)postID
           managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID MATCHES %@", postID];
    
    return (JSCPost *)[managedObjectContext cds_retrieveFirstEntryForEntityClass:[JSCPost class]
                                                                       predicate:predicate];
}

+ (instancetype)fetchPostWithID:(NSString *)postID
{
    return [JSCPost fetchPostWithID:postID
               managedObjectContext:[CDSServiceManager sharedInstance].mainManagedObjectContext];
}

@end
