//
//  JSCFeedAPIManager.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation
import EasyDownloadSession
import CoreDataServices

/**
 A set of possible feed retrieval options.
 */
enum JSCDataRetrievalOperationMode: Int {
    
    case FirstPage = 0, NextPage
}

/**
 Manages the api calls to interact with the feed.
 */
class JSCFeedAPIManager: NSObject {
    
    //MARK: Request
    
    /**
    Gets a request depending on the mode.
    
    - Parameter mode: Can be either first page or any other page.
    
    - Returns: JSCFeedRequest to retrieve the data from.
    */
    private class func requestForMode(mode: JSCDataRetrievalOperationMode) -> JSCFeedRequest {
        
        var request: JSCFeedRequest?
        
        switch mode {
            
        case .FirstPage:
            
            request = JSCFeedRequest.requestToRetrieveFeed()
            
        case .NextPage:
            
            ServiceManager.sharedInstance.backgroundManagedObjectContext.performBlockAndWait {
                
                let page = JSCPostPage.fetchLastPageInContext(ServiceManager.sharedInstance.mainManagedObjectContext)
                
                request = JSCFeedRequest.requestToRetrieveFeedNexPageWithURL(page.nextPageRequestPath!)
            }
        }
        
        return request!
    }
    
    /**
     Creates and queues an operation for retrieving the feed.
     
     - Parameter mode: first page or a next page.
     - Parameter success: callback if the request is successful.
     - Parameter failture: callback if the request fails.
     */
    class func retrieveFeedWithMode(mode: JSCDataRetrievalOperationMode, success: JSCOperationOnSuccessCallback, failure: JSCOperationOnFailureCallback) {
        
        DLog("Queuing request to retrieve feed")
        
        let request = self.requestForMode(mode)
        
        DownloadSession.scheduleDownloadWithId("retrieveFeed \(mode.rawValue)", request: request,
                                               stackIdentifier: kJSCMediaDownloadStack,
                                               progress: nil,
                                               success: { (taskInfo: DownloadTaskInfo!, responseData: NSData?) -> Void in
            
            let operation = JSCFeedParsingOperation.init(data: responseData, mode: mode)
            
            operation.onSuccess = success
            operation.onFailure = failure
            
            operation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
            
            JSCOperationCoordinator.sharedInstance.addOperation(operation)
            
            },
                                               failure: { (taskInfo: DownloadTaskInfo!, error: NSError?) -> Void in
                
                if let failure: JSCOperationOnFailureCallback = failure {
                    
                    failure(error)
                }
        })
    }
}
