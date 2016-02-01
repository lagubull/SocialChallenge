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
#import  "JSCUser.h"
#import "JSCUserParser.h"

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
        
        post.created_at = JSCValueOrDefault(postDictionary[@"created_at"],
                                            post.created_at);
        
        post.like_count = JSCValueOrDefault(postDictionary[@"like_count"],
                                            post.like_count);
        
        post.content = JSCValueOrDefault(postDictionary[@"content"],
                                         post.content);
        
        post.commentCount = JSCValueOrDefault(postDictionary[@"comment_count"],
                                              post.commentCount);
        
        JSCUserParser *userParser = [JSCUserParser parser];
        
        JSCUser *user = [userParser parseUser:postDictionary[@"user"]];
        
        post.user = JSCValueOrDefault(user,
                                      post.user);
    }
    
    return post;
}

/*
 "comment_count" = 38;
 content = "Vegan Williamsburg banh mi cardigan. Helvetica trust fund locavore American Apparel hoodie echo park mlkshk jean shorts. Skateboard master cleanse retro 8-bit. Cosby sweater whatever keffiyeh ethical. Craft beer fixie iPhone blog.";
 "created_at" = "2014-07-03T11:47:43.854Z";
 id = 100;
 "like_count" = 77;
     user =     {
     avatar = "http:schmoesknow.com/wp-content/uploads/2014/05/graces_avatar.jpg";
     "first_name" = Kara;
     "last_name" = Yost;
     };
 }
 */

@end
