//
//  JSCOperation.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 15/03/2016.
//
//

import Foundation

/**
 Success closure type.
 */
typealias JSCOperationOnSuccessCallback =  AnyObject? -> Void

/**
 Completion closure type.
 */
typealias JSCOperationOnCompletionCallback =  AnyObject? -> Void

/**
 Failure closure type.
 */
typealias JSCOperationOnFailureCallback =  NSError? -> Void

class JSCOperation:  NSOperation {
    
    /**
     Identifies the operation.
     */
    var identifier: String?
    
    /**
     Current progress of the operation.
     */
    var progress: NSProgress?
    
    /**
     Is the Operation prepared to execute.
     */
    override var ready : Bool {
        
        get {
            
            return _ready
        }
        set {
            
            willChangeValueForKey("isReady")
            _ready = newValue
            didChangeValueForKey("isReady")
        }
    }
    
    private var _ready : Bool = true
    
    /**
     Is the operation running.
     */
    override var executing : Bool {
        
        get {
            
            return _executing
        }
        set {
            
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    private var _executing : Bool = false
    
    /**
    YES - The operation has executed.
    */
    override var finished : Bool {
        
        get {
            
            return _finished
        }
        set {
            
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }
    
    private var _finished : Bool = false
    
    /**
     Return value for the operation.
     */
    var result: AnyObject?
    
    /**
     Error occurred during execution.
     */
    var error: NSError?
    
    /**
     Queue for callbacks.
     */
    var callbackQueue: NSOperationQueue?
    
    /**
     Identifies the scheduler for the operation.
     */
    var targetSchedulerIdentifier: String?
    
    /**
     Callback called when the operation completes successfully.
     */
    var onSuccess: JSCOperationOnSuccessCallback?
    
    /**
     Callback called when the operation completes with an error.
     */
    var onFailure: JSCOperationOnFailureCallback?
    
    /**
     Callback called when the operation completes.
     
     The completion closure is used instead of the success/failure closures not alongside.
     */
    var onCompletion: JSCOperationOnCompletionCallback?
    
    //MARK: Init
    
    required override init() {
        
        self.progress = NSProgress(totalUnitCount: -1)
        self.callbackQueue = NSOperationQueue.currentQueue()
        
        super.init()
        
        self.ready = true
    }
    
    //MARK: Name
    
    override var name : String? {
        
        get {
            return self.identifier
        }
        set {
            
            willChangeValueForKey("name")
            self.identifier = newValue
            didChangeValueForKey("name")
        }
    }
    
    //MARK: State
    
    override var asynchronous: Bool {
        
        return true
    }
    
    //MARK: Coalescing
    
    /**
    This method figures out if we can coalesce with another operation.
    
    @param operation - Operation to determaine if we can coalesce with.
    
    @return YES if we can coaslesce with it, NO if not.
    */
    func canCoalesceWithOperation(operation: JSCOperation) -> Bool {
        
        return self.identifier == operation.identifier
    }
    
    /**
     This method coalesces another operation with this one, so that it
     is all performed in one operation.
     
     Perform any logic here to merge the actions together.
     
     @param operation - Operation to coalesce with.
     */
    func coalesceWithOperation(operation: JSCOperation) {
        
        // Success coalescing
        if let mySuccessClosure: JSCOperationOnSuccessCallback = self.onSuccess {
            
            if let theirSuccessClosure: JSCOperationOnSuccessCallback = operation.onSuccess {
                
                self.onSuccess = { result in
                    
                    mySuccessClosure(result)
                    theirSuccessClosure(result)
                }
            }
        }
        else
        {
            if let theirSuccessClosure: JSCOperationOnSuccessCallback = operation.onSuccess {
                
                self.onSuccess = theirSuccessClosure
            }
        }
        
        // Failure coalescing
        if let myFailureClosure: JSCOperationOnFailureCallback = self.onFailure {
            
            if let theirFailureClosure: JSCOperationOnFailureCallback = operation.onFailure {
                
                self.onFailure =  { error in
                    
                    myFailureClosure(error)
                    theirFailureClosure(error)
                }
            }
        }
        else
        {
            if let theirFailureClosure: JSCOperationOnFailureCallback = operation.onFailure {
                
                self.onFailure = theirFailureClosure
            }
        }
        
        // Completion coalescing
        if let myCompletionClosure: JSCOperationOnCompletionCallback = self.onCompletion {
            
            if let theirCompletionClosure: JSCOperationOnCompletionCallback = operation.onCompletion {
                
                self.onCompletion =  { result in
                    
                    myCompletionClosure(result)
                    theirCompletionClosure(result)
                }
            }
        }
        else
        {
            if let theirCompletionClosure: JSCOperationOnCompletionCallback = operation.onCompletion {
                
                self.onCompletion = theirCompletionClosure
            }
        }
        
        /**
        We replace the other operation's progress object,
        so that anyone listening to that one, actually gets the
        progress of this operation which is doing the real work. */
        operation.progress = self.progress
    }
    
    //MARK: Control
    
    override func start() {
        
        if !self.executing {
            
            super.start()
            
            self.ready = false
            self.executing = true
            self.finished = false
            
            DLog("\(self.name!) Operation Started.");
        }
    }
    
    /**
     Finishes the execution of the operation.
     */
    func finish() {
        
        if self.executing {
            
            DLog("\(self.name!) Operation Finished.")
            
            self.executing = false
            self.finished = true
        }
    }
    
    //MARK: Callbacks
    
    /**
    Finishes the execution of the operation and calls the onSuccess callback.
    */
    func didSucceedWithResult(result: AnyObject?) {
        
        self.result = result
        
        self.finish()
        
        if self.onSuccess != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onSuccess!(result)
            })
        }
    }
    
    /**
     Finishes the execution of the operation and calls the onFailure callback.
     */
    func didFailWithError(error: NSError?) {
        
        self.error = error
        
        self.finish()
        
        if self.onFailure != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onFailure!(error)
            })
        }
    }
    
    /**
     Finishes the execution of the operation and calls the onCompletion callback.
     */
    func didCompleteWithResult(result: AnyObject?) {
        
        self.result = result
        
        self.finish()
        
        if self.onCompletion != nil {
            
            self.callbackQueue!.addOperationWithBlock({
                
                self.onCompletion!(result)
            })
        }
    }
}
