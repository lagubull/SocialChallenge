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
@property (nonatomic, copy) NSString *postId;

@end

@implementation JSCLocalImageAssetRetrievalOperation

@synthesize identifier = _identifier;

#pragma mark - Init

- (instancetype)initWithPostId:(NSString *)postId;
{
    self = [super init];
    
    if (self)
    {
        self.postId = postId;
    }
    
    return self;
}

#pragma mark - Identifier

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [NSString stringWithFormat:@"retrieveLocalImageAssetForPostId %@", self.postId];
    }
    
    return _identifier;
}

#pragma mark - Start

- (void)start
{
    [super start];
    
    UIImage *imageFromDisk = nil;
    
    NSData *imageData = [JSCFileManager retrieveDataFromDocumentsDirectoryWithPath:self.postId];
    
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