//
//  JSCPostParserTests.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import XCTest
import OCMock

import CoreDataServices

@testable import SocialChallenge

class JSCPostParserTests: XCTestCase {
    
    var parser: JSCPostParser?
    
    var postJSON: Dictionary<String, AnyObject>?
    var nilPostJSON: Dictionary<String, AnyObject>?
    
    var createdAt: String?
    var likeCount: NSNumber?
    var commentCount: NSNumber?
    var postId: String?
    var content: String?
    var userFirstName: String?
    var userLastName: String?
    var userAvatarRemoteURL: String?
    
    override func setUp() {
        
        super.setUp()
        
        CDSServiceManager.sharedInstance().setupModelURLWithModelName("SocialChallenge")
        
        self.parser = JSCPostParser.parserWithContext(CDSServiceManager.sharedInstance().mainManagedObjectContext)
        
        self.postId = "1"
        self.createdAt = "2016-03-03 12:00:00"
        self.likeCount = 2
        self.commentCount = 100
        self.content = "This is an example of post content."
        self.userFirstName = "Javier"
        self.userLastName = "Laguna"
        self.userAvatarRemoteURL = "http://someURL"
        
        let userDictionary = [ kJSCFirstName : self.userFirstName!,
            kJSCLastName : self.userLastName!,
            kJSCAvatar : self.userAvatarRemoteURL!]
        
        postJSON = [ "id" : self.postId!,
            kJSCCreatedAt : self.createdAt!,
            kJSCLikeCount : self.likeCount!,
            kJSCCommentCount : self.commentCount!,
            kJSCContent : self.content!,
            kJSCUser : userDictionary ]
        
        nilPostJSON = [ "id" : self.postId! ]
    }
    
    override func tearDown() {
        
        CDSServiceManager.sharedInstance().clear()
        
        self.createdAt = nil
        self.likeCount = nil
        self.commentCount = nil
        self.postId = nil
        self.content = nil
        self.userFirstName = nil
        self.userLastName = nil
        self.userAvatarRemoteURL = nil
        
        super.tearDown()
    }
    
    //MARK: Post
    
    func test_parsePost_postObjectReturned() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created");
    }
    
    //MARK: Properties
    
    func test_parsePost_postId() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.postId, self.postId!, "PostId property was not set properly. Was set to: \(post.postId) rather than: \(self.postId!)");
    }
    
    func test_parsePost_createdAt() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
        
        XCTAssertEqual(post.createdAt, dateFormatter.dateFromString(self.createdAt!), "CreatedAt property was not set properly. Was set to: \(post.createdAt) rather than: \(self.createdAt!)")
    }
    
    func test_parsePost_likeCount() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.likeCount, self.likeCount, "LikeCount property was not set properly. Was set to: \(post.likeCount) rather than: \(self.likeCount!)")
    }
    
    func test_parsePost_commentCount() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.commentCount, self.commentCount, "CommentCount property was not set properly. Was set to: \(post.commentCount) rather than: \(self.commentCount!)")
    }
    
    func test_parsePost_content() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.content, self.content, "Content property was not set properly. Was set to: \(post.content) rather than: \(self.content!)")
    }
    
    func test_parsePost_userFirstName() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.userFirstName, self.userFirstName, "UserFirstName property was not set properly. Was set to: \(post.userFirstName) rather than: \(self.userFirstName!)")
    }
    
    func test_parsePost_userLastName() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.userLastName, self.userLastName, "UserLastName property was not set properly. Was set to: \(post.userLastName) rather than: \(self.userLastName!)")
    }
    
    func test_parsePost_userAvatarRemoteURL() {
        
        let post = self.parser!.parsePost(self.postJSON!)
        
        XCTAssertEqual(post.userAvatarRemoteURL, self.userAvatarRemoteURL, "userAvatarRemoteURL property was not set properly. Was set to: \(post.userAvatarRemoteURL) rather than: \(self.userAvatarRemoteURL!)")
    }
    
    //MARK: PropertiesNegativePath
    
    func test_parsePost_postId_mustBePresent() {
        
        let post = self.parser!.parsePost([ "Noid" : self.postId! ])
        
         XCTAssertNil(post, "A valid post object was created")
    }
    
    //MARK: NewPost
    
    func test_parsePost_createdAt_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created")
    }
    
    func test_parsePost_likeCount_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created")
    }
    
    func test_parsePost_commentCount_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created")
    }
    
    func test_parsePost_content_newPost_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created");
    }
    
    func test_parsePost_userFirstName_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created");
    }
    
    func test_parsePost_userLastName_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created");
    }
    
    func test_parsePost_userAvatarRemoteURL_newPost_canBeNil() {
        
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertNotNil(post, "A valid post object wasn't created");
    }
    
    //MARk: ExistingPost
    
    func test_parsePost_createdAt_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
        
        XCTAssertEqual(post.createdAt, dateFormatter.dateFromString(self.createdAt!), "CreatedAt property was not set properly. Was set to: \(post.createdAt) rather than: \(self.createdAt!)")
    }
    
    func test_parsePost_likeCount_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.likeCount, self.likeCount, "LikeCount property was not set properly. Was set to: \(post.likeCount) rather than: \(self.likeCount!)")
    }
    
    func test_parsePost_commentCount_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.commentCount, self.commentCount, "CommentCount property was not set properly. Was set to: \(post.commentCount) rather than: \(self.commentCount!)")
    }
    
    func test_parsePost_content_newPost_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.content, self.content, "Content property was not set properly. Was set to: \(post.content) rather than: \(self.content!)")
    }
    
    func test_parsePost_userFirstName_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.userFirstName, self.userFirstName, "UserFirstName property was not set properly. Was set to: \(post.userFirstName) rather than: \(self.userFirstName!)")
    }
    
    func test_parsePost_userLastName_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.userLastName, self.userLastName, "UserLastName property was not set properly. Was set to: \(post.userLastName) rather than: \(self.userLastName!)")
    }
    
    func test_parsePost_userAvatarRemoteURL_existingPost_canBeNil() {
        
        _ = self.parser!.parsePost(self.postJSON!)
        let post = self.parser!.parsePost(self.nilPostJSON!)
        
        XCTAssertEqual(post.userAvatarRemoteURL, self.userAvatarRemoteURL, "userAvatarRemoteURL property was not set properly. Was set to: \(post.userAvatarRemoteURL) rather than: \(self.userAvatarRemoteURL!)")
    }
}
