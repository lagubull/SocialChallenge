//
//  JSCPostPageParser.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCParser.h"

@class JSCPostPage;

/**
 Extracts a PostPage.
 */
@interface JSCPostPageParser : JSCParser

/**
Parse Page.

@param pageDictionary - JSON containing a page.

@return JSCPostPage instance that was parsed.
*/
- (JSCPostPage *)parsePage:(NSDictionary *)pageDictionary;

@end
