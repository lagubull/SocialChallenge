//
//  JSCStack.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCStack.h"

@interface JSCStack ()

@property (nonatomic, assign, readwrite) NSInteger count;

@property (nonatomic, strong) NSMutableArray* objectsArray;

@end

@implementation JSCStack

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        _objectsArray = [[NSMutableArray alloc] init];
        _count = 0;
    }
    
    return self;
}

#pragma mark - Push

- (void)push:(id)anObject
{
    [self.objectsArray addObject:anObject];
    self.count = self.objectsArray.count;
}

#pragma mark -  Pop

- (id)pop
{
    id obj = nil;
    
    if (self.objectsArray.count > 0)
    {
        obj = [self.objectsArray lastObject];
        
        [self.objectsArray removeLastObject];
        self.count = self.objectsArray.count;
    }
    
    return obj;
}

#pragma mark - Clear

- (void)clear
{
    [self.objectsArray removeAllObjects];
    self.count = 0;
}

#pragma mark - Dealloc

- (void)dealloc
{
    self.objectsArray = nil;
}

@end
