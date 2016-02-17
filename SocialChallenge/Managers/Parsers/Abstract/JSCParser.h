//
//  JSCParser.h
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma mark - ValueOrDefault

static inline id JSCValueOrDefault(id value, id defaultValue)
{
    if (value == nil ||
        value == [NSNull null])
    {
        return defaultValue;
    }
    
    return value;
}

@interface JSCParser : NSObject

/**
 Convenience alloc/init that will return a parser instance.
 
 @return FSNParser instance.
 */
+ (instancetype)parser;

@end
