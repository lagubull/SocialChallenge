//
//  JSCFeedRetrievalOperation.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

enum DataRetrievalOperationMode : Int {
    
    case JSCFirstPage = 0, JSCNextPage
}

@objc(JSCFeedRetrievalOperation)

/**
Request to retrieve a feed.
*/
class JSCFeedRetrievalOperation : JSCCDSOperation {
    
    /**
     Indicates the type of the request for data.
     */
    private var mode : DataRetrievalOperationMode?
    
    /**
     Task to retrieve the data.
     */
    private var task : NSURLSessionTask?
    
    //Mark: Init
    
    override init() {
        
        super.init()
    }
    
    /**
    Creates an operation to retrieve a feed.
    
    - Parameter: mode indicates whether should be the first the page or second.
    
    - Returns: an instance of the class.
    */
    convenience init(mode : Int) {
        
        self.init()
        
        self.mode = DataRetrievalOperationMode (rawValue : mode)

        self.identifier = self.myIdentifier
    }
    
    //Mark - Identifier
    
    lazy var myIdentifier : String = {
        
        let _identifier : String = "retrieveFeed \(self.mode!.rawValue)"
        
        return _identifier
    }()
    
    //Mark - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        self.mode = DataRetrievalOperationMode (rawValue : aDecoder.decodeIntegerForKey("mode"))!
        
        super.init()
        
        self.identifier = self.myIdentifier
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(self.mode!.rawValue, forKey: "mode")
    }
    
    //Mark - Start
    
    override func start() {
        
        super.start()
        
        let request = self.requestForMode(self.mode!)
        
        self.task = JSCSession.defaultSession().dataTaskWithRequest (request, completionHandler : { [weak self] (data, response, error) in
            
            if (error == nil)
            {
                let feed = JSCJSONManager.processJSONData(data) as! [String : AnyObject]!
                
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
    
    //Mark - Request
    
    func requestForMode(mode : DataRetrievalOperationMode) -> JSCFeedRequest {
        
        var request : JSCFeedRequest?
        
        switch mode {
            
        case .JSCFirstPage:
            
            request = JSCFeedRequest.requestToRetrieveFeed()
            
        case .JSCNextPage:
            
            CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
                
                let page = JSCPostPage.fetchLastPageInContext(CDSServiceManager.sharedInstance().backgroundManagedObjectContext)
                
                request = JSCFeedRequest.requestToRetrieveFeedNexPageWithURL(page.nextPageRequestPath!)
            }
        }
        
        return request!
    }
    
    //Mark - Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.task!.cancel()
        
        self.didSucceedWithResult(nil)
    }
}