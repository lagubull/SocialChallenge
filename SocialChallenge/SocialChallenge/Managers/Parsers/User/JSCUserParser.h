//
//  JSCUserParser.h
//  SocialChallenge
//
//  Created by Javier Laguna on 01/02/2016.
//
//

#import "JSCParser.h"

@class JSCUser;

@interface JSCUserParser : JSCParser

/**
 Parse User.
 
 @param userDictionary - JSON containing a user.
 
 @return JSCUser instance that was parsed.
 */
- (JSCUser *)parseUser:(NSDictionary *)userDictionary;

@end
