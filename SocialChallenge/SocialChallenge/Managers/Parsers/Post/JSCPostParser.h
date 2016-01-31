//
//  JSCPostParser.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCParser.h"

@class JSCPost;

@interface JSCPostParser : JSCParser

/**
 Parse array of posts.
 
 @param postsDictionaries - array of dictionaries with posts.
 
 @return NSArray of posts.
 */
- (NSArray *)parsePosts:(NSArray *)postsDictionaries;


/**
 Parse Post.
 
 @param postsDictionary - JSON containing a post.
 
 @return JSCPostPage instance that was parsed.
 */
- (JSCPost *)parsePost:(NSDictionary *)postDictionary;

@end
