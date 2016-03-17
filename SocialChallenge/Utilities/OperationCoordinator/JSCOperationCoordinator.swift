//
//  JSCOperationCoordinator.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 16/03/2016.
//
//

import Foundation

/**
Identifier for network based operations.
*/
let kJSCNetworkDataOperationSchedulerTypeIdentifier = "kJSCNetworkDataOperationSchedulerTypeIdentifier"

/**
Identifier for local operations.
*/
let kJSCLocalDataOperationSchedulerTypeIdentifier = "kJSCLocalDataOperationSchedulerTypeIdentifier"

/**
 This class handles the schedulers that run the operations.
 */
class JSCOperationCoordinator {
    
    /**
     Contains the schedulers in the app.
     */
    lazy var schedulerDictionary: Dictionary <String, NSOperationQueue> = {
        
        return [:]
    }()
    
    //MARK: Singleton
    
    static let sharedInstance = JSCOperationCoordinator()
    
    //MARK: Register
    
    /**
    Registers a Scheduler with the coordinator.
    
    - Parameter queue -  Scheduler to register with the coordinator.
    - Parameter schedulerIdentifier Scheduler identifier to register the coordinator under.
    */
    func registerScheduler(queue: NSOperationQueue, schedulerIdentifier: String) {
        
        self.schedulerDictionary[schedulerIdentifier] = queue
    }
    
    //MARK: Add
    
    /**
    Adds operation to the scheduler, if an operation with the same identifier is on the scheduler then the coordinator
    will perform coalescing.
    
    - Parameter operation - operation to add.
    */
    func addOperation(operation: JSCOperation) {
        
        let queue = self.schedulerDictionary[operation.targetSchedulerIdentifier!]! as NSOperationQueue
        
        let coalescedOperation = self.coalesceOperation(operation, queue: queue)
        
        if coalescedOperation == nil {
            
            queue.addOperation(operation)
        }
    }
    
    //MARK: Coalescing
    
    /**
    Finds the first operation which can coalesce the passed in operation
    and coalesce with it.
    
    - Parameter operation - opearation to coaleque with.
    - Parameter scheduler - Scheduler to coalesce the operation on.
    
    - Returns the coalesced operation
    */
    func coalesceOperation(newOperation: JSCOperation, queue: NSOperationQueue) -> JSCOperation? {
        
        let operations = queue.operations
        
        for operation in operations as! Array <JSCOperation> {
            
            let canAskToCoalesce = operation.isKindOfClass(JSCOperation.self) as Bool
            
            if canAskToCoalesce &&
                operation.canCoalesceWithOperation(newOperation) {
                    
                    operation.coalesceWithOperation(newOperation)
                    
                    return operation;
            }
        }
        
        return nil;
    }
}