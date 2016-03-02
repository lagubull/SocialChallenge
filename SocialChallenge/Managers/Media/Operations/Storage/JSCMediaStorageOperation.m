//
//  JSCMediaStorageOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 17/02/2016.
//
//

#import "JSCMediaStorageOperation.h"

#import "JSCFileManager.h"
#import "UIImage+JSCRoundImage.h"
#import "UIImage+JSCScaleImage.h"

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
    
    BOOL success = NO;
    
    if (self.data)
    {
        //Images in this API are too big to have on a performant cell,
        //in a real app we would keep the original and store also a smaller resolution copy to improve performance, for the test I will only keep the preview
        
        UIImage *image = [UIImage imageWithData:self.data];
        
        image = [UIImage jsc_scaleImage:image];
        image = [UIImage jsc_roundImage:image];
        
        NSData *imageData = UIImageJPEGRepresentation(image,
                                                      1.0f);
        
        if ([JSCFileManager saveData:imageData
            toDocumentsDirectoryPath:self.postId])
        {
            [self didSucceedWithResult:image];
        }
    }
  
    if (!success)
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
