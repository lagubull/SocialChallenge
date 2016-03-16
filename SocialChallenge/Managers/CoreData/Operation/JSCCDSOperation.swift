//
//  JSCCDSOperation.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation
import CoreDataServices

@objc(JSCCDSOperation)

/**
 Code base for a core data opration.
 */
class JSCCDSOperation: JSCOperation {
    
    //MARK: Save
    
    /**
    Saves the parent managed context if there is changes.
    
    - Parameter result - result to finish with and pass to on success callback.
    */
    func saveLocalContextChangesToMainContext(result: AnyObject?) {
        
        CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
            
            var didSave = true
            
            do {
                
                try CDSServiceManager.sharedInstance().backgroundManagedObjectContext.save()
            }
            catch {
                
                let localManagedObjectContentSaveError = error as NSError
                
                NSLog("Unresolved error \(localManagedObjectContentSaveError), \(localManagedObjectContentSaveError.userInfo)")
                
                self.didFailWithError(localManagedObjectContentSaveError)
                
                didSave = false
            }
            
            if (didSave) {
                
                /*
                Coredata will delay cascading deletes for performance so we force them to happen.
                */
                CDSServiceManager.sharedInstance().backgroundManagedObjectContext.processPendingChanges()
                
                CDSServiceManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait {
                    
                    do {
                        
                        try CDSServiceManager.sharedInstance().backgroundManagedObjectContext.save()
                    }
                    catch {
                        
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        
                        self.didFailWithError(nserror)
                    }
                }
                
                if let unwrappedResult = result {

                    if (unwrappedResult.isKindOfClass(NSError.self)) {
                        
                        self.didFailWithError(unwrappedResult as? NSError)
                    }
                    else {
                        
                        self.didSucceedWithResult(unwrappedResult)
                    }
                }
                else {
                    
                    self.didSucceedWithResult(result)
                }
            }
        }
    }
    
    /**
     Saves the local managed object context and finishes the execution of the operation.
     
     - Parameter result - result to finish with and pass to on success callback.
     */
    func saveContextAndFinishWithResult(result: AnyObject?) {
        
        let hasChanges = CDSServiceManager.sharedInstance().backgroundManagedObjectContext.hasChanges;
        
        if hasChanges {
            
            self.saveLocalContextChangesToMainContext(result)
        }
        else
        {
            if let unwrappedResult = result {
                
                if (unwrappedResult.isKindOfClass(NSError.self)) {
                    
                    self.didFailWithError(unwrappedResult as? NSError)
                }
                else {
                    
                    self.didSucceedWithResult(unwrappedResult)
                }
            }
            else {
                
                self.didSucceedWithResult(result)
            }    
        }
    }
}