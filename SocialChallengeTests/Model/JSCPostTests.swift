//
//  JSCPostTests.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 23/03/2016.
//
//

import XCTest

import CoreDataServices

@testable import SocialChallenge

class JSCPostTests: XCTestCase {
    
    var post:JSCPost?
    
    var postId: String?
    var commentCount: NSNumber?
    var content: String?
    var createdAt: String?
    var likeCount: NSNumber?
    var userAvatarRemoteURL: String?
    var userFirstName: String?
    var userLastName: String?
    var page: JSCPostPage?
    
    override func setUp() {
        
        super.setUp()
       
        ServiceManager.sharedInstance.setupModelURLWithModelName("SocialChallenge")
        
        postId = "1"
        createdAt = "2016-03-03 12:00:00"
        likeCount = 2
        commentCount = 100
        content = "This is an example of post content."
        userFirstName = "Javier"
        userLastName = "Laguna"
        userAvatarRemoteURL = "http://someURL"
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
        
        page  = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPostPage.self, inManagedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? JSCPostPage
        post = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPost.self, inManagedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext) as? JSCPost
        
        post?.postId = self.postId!
        post?.commentCount = commentCount!
        post?.createdAt = dateFormatter.dateFromString(createdAt!)
        post?.content = content!
        post?.likeCount = likeCount!
        post?.userAvatarRemoteURL = userAvatarRemoteURL!
        post?.userFirstName = userFirstName!
        post?.userLastName = userLastName!
        post?.page = page!
    }
    
    override func tearDown() {
        
        ServiceManager.sharedInstance.clear()
        
        self.createdAt = nil
        self.likeCount = nil
        self.commentCount = nil
        self.postId = nil
        self.content = nil
        self.userFirstName = nil
        self.userLastName = nil
        self.userAvatarRemoteURL = nil
        self.page = nil
        self.post = nil
        
        super.tearDown()
    }
    
    func test_post_hasId() {
        
        XCTAssertEqual(post!.postId, self.postId!, "PostId property was not set properly. Was set to: \(post!.postId) rather than: \(self.postId!)");
    }
    
    func test_post_hasCreatedAt() {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
        
        XCTAssertEqual(post!.createdAt, dateFormatter.dateFromString(self.createdAt!), "CreatedAt property was not set properly. Was set to: \(post!.createdAt) rather than: \(self.createdAt!)")
    }
    
    func test_post_hasLikeCount() {
        
        XCTAssertEqual(post!.likeCount, self.likeCount, "LikeCount property was not set properly. Was set to: \(post!.likeCount) rather than: \(self.likeCount!)")
    }
    
    func test_ppost_hasCommentCount() {
        
        XCTAssertEqual(post!.commentCount, self.commentCount, "CommentCount property was not set properly. Was set to: \(post!.commentCount) rather than: \(self.commentCount!)")
    }
    
    func test_post_hasContent() {
        
        XCTAssertEqual(post!.content, self.content, "Content property was not set properly. Was set to: \(post!.content) rather than: \(self.content!)")
    }
    
    func test_post_hasUserFirstName() {
        XCTAssertEqual(post!.userFirstName, self.userFirstName, "UserFirstName property was not set properly. Was set to: \(post!.userFirstName) rather than: \(self.userFirstName!)")
    }
    
    func test_post_hasUserLastName() {
        
        XCTAssertEqual(post!.userLastName, self.userLastName, "UserLastName property was not set properly. Was set to: \(post!.userLastName) rather than: \(self.userLastName!)")
    }
    
    func test_post_hasUserAvatarRemoteURL() {
        
        XCTAssertEqual(post!.userAvatarRemoteURL, self.userAvatarRemoteURL, "UserAvatarRemoteURL property was not set properly. Was set to: \(post!.userAvatarRemoteURL) rather than: \(self.userAvatarRemoteURL!)")
    }
    
    func test_post_hasPage() {
        
        XCTAssertEqual(post!.page, self.page, "Page property was not set properly. Was set to: \(post!.userAvatarRemoteURL) rather than: \(self.userAvatarRemoteURL!)")
    }
    
    func test_post_userNameShouldBeWellFormed() {
     
        let wellFormedUseName = "Javier L."
        
        XCTAssertEqual(post!.userName(), wellFormedUseName, "User name should be well formed. Was set to: \(post!.userName()) rather than: \(wellFormedUseName)")
    }
    
    func test_post_shouldBeFetchedWithId_inAContext() {
        
        let insertedPost = JSCPost.fetchPostWithId(self.postId!, managedObjectContext: ServiceManager.sharedInstance.mainManagedObjectContext)
        
        XCTAssertEqual(insertedPost?.objectID, self.post!.objectID, "Post should be fetched by Id in a context.")
    }
    
    func test_post_shouldBeFetchedWithId_inTheMainContext() {
        
        let insertedPost = JSCPost.fetchPostWithId(self.postId!)
        
        XCTAssertEqual(insertedPost?.objectID, self.post!.objectID, "Post should be fetched by Id in a context.")
    }
}
