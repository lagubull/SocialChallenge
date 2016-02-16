//
//  JSCOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCOperation.h"

@interface JSCOperation ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

@property (atomic, assign, getter=isReady) BOOL ready;

@property (atomic, assign, getter=isExecuting) BOOL executing;

@property (atomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic, strong, readwrite) id result;

@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, strong) NSOperationQueue *callbackQueue;

@end

@implementation JSCOperation

@synthesize ready = _ready;
@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.ready = YES;
        self.progress = [NSProgress progressWithTotalUnitCount:-1];
        self.callbackQueue = [NSOperationQueue currentQueue];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    
    if (self)
    {
        self.identifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(identifier))];
        self.targetSchedulerIdentifier = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(targetSchedulerIdentifier))];
    }
    
    return self;
}

#pragma mark - Name

- (NSString *)name
{
    return self.identifier;
}

#pragma mark - State

- (void)setReady:(BOOL)ready
{
    if (_ready != ready)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isReady))];
        _ready = ready;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isReady))];
    }
}

- (BOOL)isReady
{
    return _ready;
}

- (void)setExecuting:(BOOL)executing
{
    if (_executing != executing)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
        _executing = executing;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isExecuting))];
    }
}

- (BOOL)isExecuting
{
    return _executing;
}

- (void)setFinished:(BOOL)finished
{
    if (_finished != finished)
    {
        [self willChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
        _finished = finished;
        [self didChangeValueForKey:NSStringFromSelector(@selector(isFinished))];
    }
}

- (BOOL)isFinished
{
    return _finished;
}

- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark - Coalescing

- (BOOL)canCoalesceWithOperation:(JSCOperation *)operation
{
    return [self.identifier isEqualToString:operation.identifier];
}

- (void)coalesceWithOperation:(JSCOperation *)operation
{
    // Success coalescing
    void (^mySuccessBlock)(id result) = [_onSuccess copy];
    void (^theirSuccessBlock)(id result) = [operation->_onSuccess copy];
    
    self.onSuccess = ^(id result)
    {
        if (mySuccessBlock)
        {
            mySuccessBlock(result);
        }
        
        if (theirSuccessBlock)
        {
            theirSuccessBlock(result);
        }
    };
    
    // Failure coalescing
    void (^myFailureBlock)(NSError *error) = [_onFailure copy];
    void (^theirFailureBlock)(NSError *error) = [operation->_onFailure copy];
    
    self.onFailure = ^(NSError *error)
    {
        if (myFailureBlock)
        {
            myFailureBlock(error);
        }
        
        if (theirFailureBlock)
        {
            theirFailureBlock(error);
        }
    };
    
    /*
     We replace the other operation's progress object,
     so that anyone listening to that one, actually gets the
     progress of this operation which is doing the real work. */
    operation.progress = self.progress;
}

#pragma mark - Control

- (void)start
{
    if (!self.isExecuting)
    {
        [super start];
        
        self.ready = NO;
        self.executing = YES;
        self.finished = NO;
        
        DLog(@"\"%@\" Operation Started.", self.name);
    }
}

- (void)finish
{
    if (self.executing)
    {
        DLog(@"\"%@\" Operation Finished.", self.name);
        
        self.executing = NO;
        self.finished = YES;
    }
}

#pragma mark - Callbacks

- (void)didSucceedWithResult:(id)result
{
    self.result = result;
    
    [self finish];
    
    if (self.onSuccess)
    {
        [self.callbackQueue addOperationWithBlock:^
         {
             self.onSuccess(result);
         }];
    }
};

- (void)didFailWithError:(NSError *)error
{
    self.error = error;
    
    [self finish];
    
    if (self.onFailure)
    {
        [self.callbackQueue addOperationWithBlock:^
         {
             self.onFailure(error);
         }];
    }
};

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.identifier
                  forKey:NSStringFromSelector(@selector(identifier))];
    
    [aCoder encodeObject:self.targetSchedulerIdentifier
                  forKey:NSStringFromSelector(@selector(targetSchedulerIdentifier))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSCOperation *newOperation = [[self.class allocWithZone:zone] init];
    
    newOperation.callbackQueue = _callbackQueue;
    
    newOperation.identifier = [_identifier copy];
    newOperation.targetSchedulerIdentifier = [_targetSchedulerIdentifier copy];
    
    newOperation.onSuccess = [_onSuccess copy];
    newOperation.onFailure = [_onFailure copy];
    
    return newOperation;
}

@end