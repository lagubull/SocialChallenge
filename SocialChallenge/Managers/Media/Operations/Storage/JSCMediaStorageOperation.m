//
//  JSCMediaStorageOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import "JSCMediaStorageOperation.h"

#import "JSCFileManager.h"

@interface JSCMediaStorageOperation ()

/**
 ID of the post the media is related to.
 */
@property (nonatomic, copy) NSString *postID;

/**
 Indicates where the object has been stored by default.
 */
@property (nonatomic, strong) NSURL *location;;

@end

@implementation JSCMediaStorageOperation

@synthesize identifier = _identifier;

#pragma mark - Init

- (instancetype)initWithPostID:(NSString *)postID
                      location:(NSURL *)location;
{
    self = [super init];
    
    if (self)
    {
        self.postID = postID;
        self.location = location;
    }
    
    return self;
}

#pragma mark - Identifier

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [NSString stringWithFormat:@"storeLocalImageAssetForPostID %@", self.postID];
    }
    
    return _identifier;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        self.postID = [decoder decodeObjectForKey:NSStringFromSelector(@selector(postID))];
        self.location = [decoder decodeObjectForKey:NSStringFromSelector(@selector(location))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.postID
                   forKey:NSStringFromSelector(@selector(postID))];
    
    [encoder encodeObject:self.location
                   forKey:NSStringFromSelector(@selector(location))];
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    if ([JSCFileManager moveFileFromSourcePath:[self.location absoluteString]
                             toDestinationPath:self.postID])
    {
        [self didSucceedWithResult:nil];
    }
    else
    {
        [self didFailWithError:nil];
    }
}

#pragma mark - Cancel

- (void)cancel
{
    [super cancel];
    
    [self didSucceedWithResult:nil];
}

@end
