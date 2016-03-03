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

/**
 Post JSON Keys.
 */
NSString * const kJSCPostId = @"id";
NSString * const kJSCLikeCount = @"like_count";
NSString * const kJSCCommentCount = @"comment_count";
NSString * const kJSCContent = @"content";
NSString * const kJSCUser = @"user";
NSString * const kJSCAvatar = @"avatar";
NSString * const kJSCFirstName = @"first_name";
NSString * const kJSCLastName = @"last_name";
NSString * const kJSCCreatedAt = @"created_at";

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
    
    if (postDictionary[kJSCPostId])
    {
        NSString *postId = [NSString stringWithFormat:@"%@",postDictionary[kJSCPostId]];
        
        post = [JSCPost fetchPostWithId:postId
                   managedObjectContext:self.managedContext];
        if (!post)
        {
            post = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JSCPost class])
                                                 inManagedObjectContext:self.managedContext];
            
            post.postId = postId;
        }
        
        NSDateFormatter *dateFormatter = [NSDateFormatter jsc_dateFormatter];
        
        post.createdAt = JSCValueOrDefault([dateFormatter dateFromString:postDictionary[kJSCCreatedAt]],
                                           post.createdAt);
        
        post.likeCount = JSCValueOrDefault(postDictionary[kJSCLikeCount],
                                           post.likeCount);
        
        post.content = JSCValueOrDefault(postDictionary[kJSCContent],
                                         post.content);
        
        post.commentCount = JSCValueOrDefault(postDictionary[kJSCCommentCount],
                                              post.commentCount);
        
        post.userAvatarRemoteURL = JSCValueOrDefault(postDictionary[kJSCUser][kJSCAvatar], post.userAvatarRemoteURL);
        post.userFirstName = JSCValueOrDefault(postDictionary[kJSCUser][kJSCFirstName], post.userFirstName);
        post.userLastName = JSCValueOrDefault(postDictionary[kJSCUser][kJSCLastName], post.userLastName);
    }
    
    return post;
}

@end
