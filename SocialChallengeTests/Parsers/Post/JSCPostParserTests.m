//
//  JSCPostParserTests.m
//  SocialChallenge
//
//  Created by Javier Laguna on 03/03/2016.
//
//

#import <XCTest/XCTest.h>
#import <CDSServiceManager.h>

#import "JSCPost.h"
#import "JSCPostPage.h"
#import "JSCPostParser.h"

@interface JSCPostParserTests : XCTestCase

@property (nonatomic, strong) JSCPostParser *parser;

@property (nonatomic, strong) NSDictionary *postJSON;

@property (nullable, nonatomic, strong) NSString *createdAt;
@property (nullable, nonatomic, strong) NSNumber *likeCount;
@property (nullable, nonatomic, strong) NSNumber *commentCount;
@property (nullable, nonatomic, strong) NSString *postId;
@property (nullable, nonatomic, strong) NSString *content;
@property (nullable, nonatomic, strong) NSString *userFirstName;
@property (nullable, nonatomic, strong) NSString *userLastName;
@property (nullable, nonatomic, strong) NSString *userAvatarRemoteURL;

@property (nullable, nonatomic, strong) JSCPost *insertedPost;

@property (nonatomic, strong) id bundleMock;

@end

@implementation JSCPostParserTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    [[CDSServiceManager sharedInstance] setupModelURLWithModelName:@"SocialChallenge"];
    
    self.parser = [JSCPostParser parserWithContext:[CDSServiceManager sharedInstance].backgroundManagedObjectContext];
    
    self.postId = @"1";
    self.createdAt = @"2016-03-03 12:00:00";
    self.likeCount = @(2);
    self.commentCount = @(100);
    self.content = @"This is an example of post content.";
    self.userFirstName = @"Javier";
    self.userLastName = @"Laguna";
    self.userAvatarRemoteURL = @"http://someURL";
    
    NSDictionary *userDictionary = @{ kJSCFirstName : self.userFirstName,
                                      kJSCLastName : self. userLastName,
                                      kJSCAvatar : self.userAvatarRemoteURL};
    
    self.postJSON = @{ kJSCPostId : self.postId,
                       kJSCCreatedAt : self.createdAt,
                       kJSCLikeCount : self.likeCount,
                       kJSCCommentCount : self.commentCount,
                       kJSCContent : self.content,
                       kJSCUser : userDictionary };
    
}

- (void)tearDown
{
    [[CDSServiceManager sharedInstance] clear];
    
    self.createdAt = nil;
    self.likeCount = nil;
    self.commentCount = nil;
    self.postId = nil;
    self.content = nil;
    self.userFirstName = nil;
    self.userLastName = nil;
    self.userAvatarRemoteURL = nil;
    
    [super tearDown];
}

#pragma mark - Post

- (void)test_parsePost_postObjectReturned
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertNotNil(post, @"A valid post object wasn't created");
}

#pragma mark - Properties

- (void)test_parsePost_postId
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.postId, self.postId, @"PostId property was not set properly. Was set to: %@ rather than: %@", post.postId, self.postId);
}

- (void)test_parsePost_createdAt
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
    
    XCTAssertEqualObjects(post.createdAt, [dateFormatter dateFromString:self.createdAt], @"CreatedAt property was not set properly. Was set to: %@ rather than: %@", post.createdAt, self.createdAt);
}

- (void)test_parsePost_likeCount
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.likeCount, self.likeCount, @"LikeCount property was not set properly. Was set to: %@ rather than: %@", post.likeCount, self.likeCount);
}

- (void)test_parsePost_commentCount
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.commentCount, self.commentCount, @"CommentCount property was not set properly. Was set to: %@ rather than: %@", post.commentCount, self.commentCount);
}

- (void)test_parsePost_content
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.content, self.content, @"Content property was not set properly. Was set to: %@ rather than: %@", post.content, self.content);
}

- (void)test_parsePost_userFirstName
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.userFirstName, self.userFirstName, @"UserFirstName property was not set properly. Was set to: %@ rather than: %@", post.userFirstName, self.userFirstName);
}

- (void)test_parsePost_userLastName
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.userLastName, self.userLastName, @"UserLastName property was not set properly. Was set to: %@ rather than: %@", post.userLastName, self.userLastName);
}

- (void)test_parsePost_userAvatarRemoteURL
{
    JSCPost *post = [self.parser parsePost:self.postJSON];
    
    XCTAssertEqualObjects(post.userAvatarRemoteURL, self.userAvatarRemoteURL, @"Content property was not set properly. Was set to: %@ rather than: %@", post.userAvatarRemoteURL, self.userAvatarRemoteURL);
}

@end
