//
//  JSCParser.m
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCParser.h"

@implementation JSCParser

#pragma mark - Parser

+ (instancetype)parserWithContext:(NSManagedObjectContext *)managedContext
{
    JSCParser *parser = [[self.class alloc] init];
    
    parser.managedContext = managedContext;
    
    return parser;
}

#pragma mark - Init

- (instancetype)init
{
    return [self initWithContext:nil];
}

- (instancetype)initWithContext:(NSManagedObjectContext *)managedContext
{
    self = [super init];
    
    if (self)
    {
        self.managedContext = managedContext;
    }
    
    return self;
}

@end
