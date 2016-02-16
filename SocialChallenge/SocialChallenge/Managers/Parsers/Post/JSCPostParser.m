//
//  JSCPostParser.m
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCPostParser.h"

#import "JSCPost.h"
#import "CDSServiceManager.h"
#import "NSDateFormatter+JSCDateFormatter.h"
#import "JSCPost+CoreDataProperties.h"

@implementation JSCPostParser

#pragma mark Posts

- (NSArray *)parsePosts:(NSArray *)postsDictionaries
{
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *postDictionary in postsDictionaries)
    {
        [posts addObject:[self parsePost:postDictionary]];
    }
    
    return posts;
}

#pragma mark - Post

- (JSCPost *)parsePost:(NSDictionary *)postDictionary
{
    JSCPost *post = nil;
    
    if (postDictionary[@"id"])
    {
        NSString *postID = [NSString stringWithFormat:@"%@", postDictionary[@"id"]];
        
        post = [JSCPost fetchPostWithID:postID
                   managedObjectContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
        if (!post)
        {
            post = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JSCPost class])
                                                 inManagedObjectContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
            
            post.postID = postID;
        }
        
        NSDateFormatter *dateFormatter = [NSDateFormatter jsc_dateFormatter];
        
        post.createdAt = JSCValueOrDefault([dateFormatter dateFromString:postDictionary[@"created_at"]],
                                           post.createdAt);
        
        post.likeCount = JSCValueOrDefault(postDictionary[@"like_count"],
                                           post.likeCount);
        
        post.content = JSCValueOrDefault(postDictionary[@"content"],
                                         post.content);
        
        post.commentCount = JSCValueOrDefault(postDictionary[@"comment_count"],
                                              post.commentCount);
        
        post.userAvatarRemoteURL = JSCValueOrDefault(postDictionary[@"user"][@"avatar"], post.userAvatarRemoteURL);
        post.userFirstName = JSCValueOrDefault(postDictionary[@"user"][@"first_name"], post.userFirstName);
        post.userLastName = JSCValueOrDefault(postDictionary[@"user"][@"last_name"], post.userLastName);
    }
    
    return post;
}

@end
