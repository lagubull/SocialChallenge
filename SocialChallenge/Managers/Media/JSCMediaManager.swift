//
//  JSCMediaManager.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 16/03/2016.
//
//

import Foundation

import EasyDownloadSession

/**
Manages the media retrival processes.
*/
class JSCMediaManager {
    
    /**
     Retrieves a media for a post.
     
     - Parameter post: post which we want media for.
     - Parameter retrievalRequired: block to execute while a download is in progress.
     - Parameter succes: closure to execute in case of success.
     - Parameter failure: closure to execute on failure.
     */
    class func retrieveMediaForPost(post: JSCPost, retrievalRequired: ((postId: String) -> Void)?, success: ((result: AnyObject?, postId: String) -> Void)?, failure: ((error: NSError?, postId: String) -> Void)?) {
        
        if post.userAvatarRemoteURL != nil {
            
            let operation = JSCLocalImageAssetRetrievalOperation.init(postId: post.postId!)
            
            operation.onCompletion = { JSCOperationOnCompletionCallback in
                
                if let imageMedia = JSCOperationOnCompletionCallback {
                    
                    if let success: (result: AnyObject?, postId: String) -> Void = success {
                        
                        success(result: imageMedia, postId: post.postId!);
                    }
                }
                else {
                    
                    if let retrievalRequired: (postId: String) -> Void = retrievalRequired {
                            
                            retrievalRequired(postId: post.postId!);
                    }
                    
                    EDSDownloadSession.scheduleDownloadWithId(post.postId, fromURL: NSURL.init(string: post.userAvatarRemoteURL!), stackIdentifier: kJSCMediaDownloadStack, progress: nil, success: { (taskInfo, responseData) -> Void in

                        let storeOperation = JSCMediaStorageOperation.init(postId: post.postId!, data: responseData)
                        
                        storeOperation.onSuccess = { JSCOperationOnSuccessCallback in
                        
                            if let imageMedia = JSCOperationOnSuccessCallback {
                                
                                if let success: (result: AnyObject?, postId: String) -> Void = success {
                                    
                                    success(result: imageMedia, postId: post.postId!);
                                }
                            }
                            else {
                                
                                if let failure: (error: NSError?, postId: String) -> Void = failure {
                                    
                                    failure(error: nil, postId: post.postId!);
                                }
                            }
                        }
                        
                         storeOperation.onFailure = { JSCOperationOnFailureCallback in
                            
                            if let failure: (error: NSError?, postId: String) -> Void = failure {
                                
                                failure(error: nil, postId: post.postId!);
                            }
                        }
                        
                        storeOperation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
                    
                        JSCOperationCoordinator.sharedInstance.addOperation(storeOperation)
                        }, failure: { (taskInfo, error) -> Void in
                            
                            if let failure: (error: NSError?, postId: String) -> Void = failure {
                                
                                failure(error: error, postId: post.postId!);
                            }
                    })
                }
            }
            
            operation.targetSchedulerIdentifier = kJSCLocalDataOperationSchedulerTypeIdentifier;
            
            JSCOperationCoordinator.sharedInstance.addOperation(operation)
        }
        else
        {
            if let failure: (error: NSError?, postId: String) -> Void = failure {
                
                failure(error: nil, postId: post.postId!);
            }
        }
    }
}