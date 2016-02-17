//
//  JSCLocalImageAssetRetrievalOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 16/02/2016.
//
//

#import "JSCLocalImageAssetRetrievalOperation.h"

#import "CDSServiceManager.h"
#import "JSCPost.h"
#import "JSCFileManager.h"

@interface JSCLocalImageAssetRetrievalOperation ()

/**
 ID of the post the media is related to.
 */
@property (nonatomic, copy) NSString *postID;

@end

@implementation JSCLocalImageAssetRetrievalOperation

@synthesize identifier = _identifier;

#pragma mark - Init

- (instancetype)initWithPostID:(NSString *)postID;
{
    self = [super init];
    
    if (self)
    {
        self.postID = postID;
    }
    
    return self;
}

#pragma mark - Identifier

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [NSString stringWithFormat:@"retrieveLocalImageAssetForPostID %@", self.postID];
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
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.postID
                    forKey:NSStringFromSelector(@selector(postID))];
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    UIImage *imageFromDisk = nil;
    
    NSData *imageData = [JSCFileManager retrieveDataFromDocumentsDirectoryWithPath:self.postID];
    
    if (imageData)
    {
        imageFromDisk = [UIImage imageWithData:imageData];
    }
    
    [self didCompleteWithResult:imageFromDisk];
}

#pragma mark - Cancel

- (void)cancel
{
    [super cancel];
    
    [self didSucceedWithResult:nil];
}

@end