//
//  JSCFeedAPIManager.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 12/03/2016.
//
//

import Foundation

/**
 Manages the api calls to interact with the feed.
*/
class JSCFeedAPIManager: NSObject {

    /**
    Cretes and queues an operation for retrieving the feed
    
    @param mode first page or a next page
    @param success callback if the request is successful
    @param failture callback if the request fails
    */
    class func retrieveFeedWithMode(mode: JSCDataRetrievalOperationMode, success: JSCOperationOnSuccessCallback, failure:JSCOperationOnFailureCallback) {
        
        DLog("Queuing request to retrieve feed")
        
        let operation = JSCFeedRetrievalOperation.init(mode: mode)
        
        operation.onSuccess = success
        operation.onFailure = failure
        
        operation.targetSchedulerIdentifier = kJSCNetworkDataOperationSchedulerTypeIdentifier;
        
        JSCOperationCoordinator.sharedInstance.addOperation(operation)
    }
}
