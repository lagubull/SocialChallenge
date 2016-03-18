//
//  JSCFileManager.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 18/03/2016.
//
//

import Foundation

/**
Root directory for the contents of the app.
*/
let kJSCLocalDirectory: String = "SocialChallenge"

class JSCFileManager {
    
    //MARK: Documents
    
    /**
    Path of documents directory.
    
    - Returns NSString instance.
    */
    class func documentsDirectoryPath() -> NSURL!
    {
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last
        
        return directoryURL!
    }
    
    /**
     Path of resource in documents directory.
     
     - Parameter path - path that will be combined documents path.
     
     - Returns: Combined path.
     */
    class func documentsDirectoryPathForResourceWithPath(path: String?) -> String! {
        
        var documentsDirectory = self.documentsDirectoryPath()
        
        documentsDirectory = documentsDirectory.URLByAppendingPathComponent(kJSCLocalDirectory)
        
        if let path = path {

            documentsDirectory.URLByAppendingPathComponent(path)
        }
        
        return documentsDirectory.path!
    }
    
    //MARK: Retrieval
    
    /**
    Retrieves data to path in document directory for this particular application.
    
    - Parameter path - path that will be combined documents path.
    
    - Returns: NSData that was retrieved.
    */
    class func retrieveDataFromDocumentsDirectoryWithPath(path: String) -> NSData? {
        
        let extendedPath = self.documentsDirectoryPathForResourceWithPath(path) as String
        
        return NSData.init(contentsOfFile: extendedPath)
    }
    
    //MARK: Saving
    
    /**
    Save data to path in document directory.
    
    - Parameter data - data to be saved.
    - Parameter toDocumentsDirectoryPath - path that will be combined documents path.
    
    - Returns: YES whether save was successful.
    */
    class func saveData(data: NSData, toDocumentsDirectoryPath: String) -> Bool {
        
        let documentsDirectory = self.documentsDirectoryPathForResourceWithPath(toDocumentsDirectoryPath)
        
        return self.saveData(data, toPath:documentsDirectory)
    }
    
    /**
     Save data to path on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter data - data to be saved.
     - parameter path - path that the data will be saved to.
     
     - Returns: BOOL whether save was successful.
     */
    class func saveData(data: NSData, toPath: String) -> Bool {
        
        var success = false
        
        if data.length > 0 && !toPath.isEmpty {
            
            var createdDirectory = true
            
            let folderPath = NSURL(fileURLWithPath: toPath).URLByDeletingLastPathComponent!.path
            
            if let folderPath = folderPath {
                
                if !NSFileManager.defaultManager().fileExistsAtPath(folderPath) {
                    
                    createdDirectory = self.createDirectoryAtPath(folderPath)
                }
                
                if createdDirectory {
                    
                    do {
                        
                        success = true
                        try data.writeToFile(toPath, options: NSDataWritingOptions.AtomicWrite)
                    }
                    catch {
                        
                        success = false
                        let nserror = error as NSError
                        
                        NSLog("Error when attempting to write data to directory \(nserror), \(nserror.userInfo)")
                    }
                    
                }
            }
        }
        
        return success;
    }
    
    /**
     Creates directory on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter path - path that will be created.
     
     - Returns: YES whether creation was successful.
     */
    class func createDirectoryAtPath(path: String) -> Bool {
        
        var createdDirectory = false
        
        if !path.isEmpty {
            
            do {
                
                createdDirectory = true
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
                createdDirectory = false
                let nserror = error as NSError
                
                NSLog("Error when creating a directory at location: \(path): \(nserror.userInfo)")
            }
        }
        
        return createdDirectory;
    }
    
    //MARK: Deletion
    
    /**
    Delete data from path in document directory.
    
    - Parameter path - path that will be combined documents path.
    
    - Returns: YES whether deletion was successful.
    */
    class func deleteDataFromDocumentDirectoryWithPath(path: String?) -> Bool {
        
        let documentsDirectory = self.documentsDirectoryPathForResourceWithPath(path)
        
        return self.deleteDataAtPath(documentsDirectory)
    }
    
    /**
     Delete data from path.
     
     - Parameter path - path to the file.
     
     - Returns YES whether deletion was successful.
     */
    class func deleteDataAtPath(path: String) -> Bool {
        
        var success = true
        
        do {
            
            try NSFileManager.defaultManager().removeItemAtPath(path)
        }
        catch {
            
            success = false
            
            let nserror = error as NSError
            
            NSLog("Error when attempting to delete data from disk: \(nserror.userInfo)")
        }
        
        return success;
    }
}