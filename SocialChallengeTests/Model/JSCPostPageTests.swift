//
//  JSCPostPageTests.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 23/03/2016.
//
//

import XCTest

import CoreDataServices

@testable import SocialChallenge

class JSCPostPageTests: XCTestCase {
    
    
    var index: NSNumber?
    var nextPageRequestPath: String?
    var post: JSCPost?
    
    var page: JSCPostPage?
    
    override func setUp() {
        
        super.setUp()
        
        page  = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPostPage.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext) as? JSCPostPage
        post = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPost.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext) as? JSCPost
        
        index = -1
        nextPageRequestPath = "new request"
        
        page?.nextPageRequestPath = nextPageRequestPath!
        page?.index = index!
        page?.post = post!
        
        CDSServiceManager.sharedInstance().setupModelURLWithModelName("SocialChallenge")
    }
    
    override func tearDown() {
        
        CDSServiceManager.sharedInstance().clear()
        
        page  = nil
        post = nil
        index = nil
        nextPageRequestPath = nil
        
        super.tearDown()
    }
    
    func test_postPage_hasIndex() {
        
        XCTAssertEqual(page!.index, self.index!, "Index property was not set properly. Was set to: \(page!.index) rather than: \(self.index!)");
    }
    
    func test_postPage_hasNextPageRequestPath() {
        
        XCTAssertEqual(page!.nextPageRequestPath, self.nextPageRequestPath!, "NextPageRequestPath property was not set properly. Was set to: \(page!.nextPageRequestPath) rather than: \(self.nextPageRequestPath!)");
    }
    
    func test_postPage_hasPost() {
        
        XCTAssertEqual(page!.post, self.post!, "Indez property was not set properly. Was set to: \(page!.post) rather than: \(self.post!)");
    }
    
    func test_postPage_shouldFetcheLastPage() {
        
        let page1 = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPostPage.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext) as! JSCPostPage
        let page2 = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPostPage.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext) as! JSCPostPage
        let page3 = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPostPage.self, inManagedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext) as! JSCPostPage
        
        page1.index = 1
        page2.index = 2
        page3.index = 3
        
        let lastPage = JSCPostPage.fetchLastPageInContext( CDSServiceManager.sharedInstance().mainManagedObjectContext)
        
        XCTAssertEqual(lastPage.objectID, page3.objectID, "Last Page should be fetched.")
    }
}