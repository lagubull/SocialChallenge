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
            
            post.postId = postID;

        }
    }
    
    return post;
}

@end
