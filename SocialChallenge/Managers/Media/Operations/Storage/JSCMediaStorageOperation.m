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
@property (nonatomic, copy) NSString *postId;

/**
 Indicates where the object has been stored by default.
 */
@property (nonatomic, strong) NSData *data;;

@end

@implementation JSCMediaStorageOperation

@synthesize identifier = _identifier;

#pragma mark - Init

- (instancetype)initWithPostID:(NSString *)postId
                          data:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        self.postId = postId;
        self.data = data;
    }
    
    return self;
}

#pragma mark - Identifier

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [NSString stringWithFormat:@"storeLocalImageAssetForPostId %@", self.postId];
    }
    
    return _identifier;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self)
    {
        self.postId = [decoder decodeObjectForKey:NSStringFromSelector(@selector(postId))];
        self.data = [decoder decodeObjectForKey:NSStringFromSelector(@selector(data))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.postId
                   forKey:NSStringFromSelector(@selector(postId))];
    
    [encoder encodeObject:self.data
                   forKey:NSStringFromSelector(@selector(data))];
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    if ([JSCFileManager saveData:self.data
        toDocumentsDirectoryPath:self.postId])
    {
        [self didSucceedWithResult:[UIImage imageWithData:self.data]];
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
