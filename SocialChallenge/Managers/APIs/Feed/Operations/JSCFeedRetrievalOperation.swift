//
//  JSCFeedRetrievalOperation.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

/**
 A set of possible feed retrieval options.
 */
@objc enum JSCDataRetrievalOperationMode: Int {
    
    case FirstPage = 0, NextPage
}

@objc(JSCFeedRetrievalOperation)

/**
Request to retrieve a feed.
*/
class JSCFeedRetrievalOperation: JSCCDSOperation {
    
    /**
     Indicates the type of the request for data.
     */
    private var mode: JSCDataRetrievalOperationMode?
    
    /**
     Task to retrieve the data.
     */
    private var task: NSURLSessionTask?
    
    //MARK: Init
    
    /**
    Default initialiser.
    
    - Returns: an instance of the class.
    */
    override init() {
        
        super.init()
    }
    
    /**
    Creates an operation to retrieve a feed.
    
    - Parameter: mode indicates whether should be the first the page or second.
    
    - Returns: an instance of the class.
    */
    convenience init(mode: Int) {
        
        self.init()
        
        self.mode = JSCDataRetrievalOperationMode (rawValue: mode)

        self.identifier = self.myIdentifier
    }
    
    //MARK: Identifier
    
    /**
    We need to create new identifier variable as we cannot override from the parent
    */
    lazy var myIdentifier: String = {
        
            //TODO: override from the parent when migrated to Swift
        let _identifier: String = "retrieveFeed \(self.mode!.rawValue)"
        
        return _identifier
    }()
    
    //MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        self.mode = JSCDataRetrievalOperationMode (rawValue: aDecoder.decodeIntegerForKey("mode"))!
        
        super.init()
        
        self.identifier = self.myIdentifier
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(self.mode!.rawValue, forKey: "mode")
    }
    
    //MARK: Start
    
    override func start() {
        
        super.start()
        
        let request = self.requestForMode(self.mode!)
        
        self.task = JSCSession.defaultSession().dataTaskWithRequest (request, completionHandler: { [weak self] (data, response, error) in
            
            if error == nil {
                
                let feed = JSCJSONManager.processJSONData(data) as! [String: AnyObject]!
                
                let pageParser = JSCPostPageParser.parserWithContext(CDSServiceManager.sharedInstance().backgroundManagedObjectContext)
                
                CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
                    
                    pageParser.parsePage(feed)
                }
                
                self?.saveContextAndFinishWithResult(nil)
            }
            else {
                
                self?.didFailWithError(error)
            }
            })
        
        self.task!.resume()
    }
    
    //MARK: Request
    
    /**
    Gets a request depending on the mode.
    
    - Parameter mode Can be either first page or any other page.
    - Return: JSCFeedRequest to retrieve the data from.
    */
    func requestForMode(mode: JSCDataRetrievalOperationMode) -> JSCFeedRequest {
        
        var request: JSCFeedRequest?
        
        switch mode {
            
        case .FirstPage:
            
            request = JSCFeedRequest.requestToRetrieveFeed()
            
        case .NextPage:
            
            CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
                
                let page = JSCPostPage.fetchLastPageInContext(CDSServiceManager.sharedInstance().backgroundManagedObjectContext)
                
                request = JSCFeedRequest.requestToRetrieveFeedNexPageWithURL(page.nextPageRequestPath!)
            }
        }
        
        return request!
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.task!.cancel()
        
        self.didSucceedWithResult(nil)
    }
}