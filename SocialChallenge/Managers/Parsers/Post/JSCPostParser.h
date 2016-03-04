//
//  JSCPostParser.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCParser.h"

@class JSCPost;

/**
 Post JSON Keys.
 */
extern NSString * const kJSCPostId;
extern NSString * const kJSCLikeCount;
extern NSString * const kJSCCommentCount;
extern NSString * const kJSCContent;
extern NSString * const kJSCUser;
extern NSString * const kJSCAvatar;
extern NSString * const kJSCFirstName;
extern NSString * const kJSCLastName;
extern NSString * const kJSCCreatedAt;

/**
 Extracts a Post.
 */
@interface JSCPostParser : JSCParser

/**
 Parse array of posts.
 
 @param postsDictionaries - array of dictionaries with posts.
 
 @return NSArray of posts.
 */
- (NSArray *)parsePosts:(NSArray *)postsDictionaries;


/**
 Parse Post.
 
 @param postDictionary - JSON containing a post.
 
 @return JSCPostPage instance that was parsed.
 */
- (JSCPost *)parsePost:(NSDictionary *)postDictionary;

@end
