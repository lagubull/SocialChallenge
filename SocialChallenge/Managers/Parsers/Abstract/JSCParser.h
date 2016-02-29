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

/**
 Convenient method to check if a value is not nil and returns ir or the default
 */
static inline id JSCValueOrDefault(id value, id defaultValue)
{
    if (value == nil ||
        value == [NSNull null])
    {
        return defaultValue;
    }
    
    return value;
}

/**
 Code base for the parsers.
 */
@interface JSCParser : NSObject

/**
 Context for the parser to access CoreData.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedContext;

/**
 Convenient initialiser the parser.
 
 @param managedContext - Context for the parser to access CoreData.
 
 @return FSNParser instance.
 */
+ (instancetype)parserWithContext:(NSManagedObjectContext *)managedContext;

/**
 Initialises the parser.
 
 @param managedContext - Context for the parser to access CoreData.
 
 @return FSNParser instance.
 */
- (instancetype)initWithContext:(NSManagedObjectContext *)managedContext NS_DESIGNATED_INITIALIZER;

/**
 Initialises the parser.
 
 This method must not be used as the context is a mandatory property.
 */
- (instancetype)init __attribute__((unavailable("Please use InitWithContext")));

@end
