//
//  JSCFeedParsingOperation.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

/**
 parses the data corresponding to a feed.
 */
class JSCFeedParsingOperation: JSCCDSOperation {
    
    /**
     Indicates the type of the request for data.
     */
    private var mode: JSCDataRetrievalOperationMode?
    
    /**
     Data to parse.
     */
    private var data: NSData?
    
    //MARK: Init
    
    /**
    Creates an operation to retrieve a feed.
    
    - Parameter: data: actual data to parse.
    - Parameter: mode: indicates whether should be the first the page or second.
    
    - Returns: an instance of the class.
    */
    required convenience init(data: NSData, mode: JSCDataRetrievalOperationMode) {
        
        self.init()
        
        self.data = data
        self.mode = mode
    }
    
    //MARK: Identifier
    
    override var identifier: String? {
        
        get {
            
            return _identifier
        }
        set {
            
            willChangeValueForKey("identifier")
            self._identifier = newValue!
            didChangeValueForKey("identifier")
        }
    }
    
    private lazy var _identifier: String = {
        
        return "parseFeedForMode\(self.mode!.rawValue)"
    }()
    
    //MARK: Start
    
    override func start() {
        
        super.start()
        
        let feed = JSCJSONManager.processJSONData(self.data!)
        
        let pageParser = JSCPostPageParser.parserWithContext(CDSServiceManager.sharedInstance().backgroundManagedObjectContext)
        
        CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
            
            pageParser.parsePage(feed)
            
            self.saveContextAndFinishWithResult(nil)
        }
    }
    
    //MARK: Cancel
    
    override func cancel() {
        
        super.cancel()
        
        self.didSucceedWithResult(nil)
    }
}