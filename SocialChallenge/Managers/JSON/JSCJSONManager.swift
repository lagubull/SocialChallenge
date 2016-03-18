//
//  JSCJSONManager.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 17/03/2016.
//
//

import Foundation

/**
 Manages the encoding and decoding of JSON files.
*/
class JSCJSONManager {
    
    /**
     Reads the data and deserialises it in a NSdictionary
     
     - Parameter data - data to process
     
     - Returns: Dictionary with the processed information
     */
    class func processJSONData(data: AnyObject) -> Dictionary <String, AnyObject> {
        
        var resultDictionary: Dictionary <String, AnyObject>?
        
        let dataMirror = Mirror(reflecting: data)
        
        if dataMirror.subjectType != Dictionary <String, AnyObject>.self {
            
            var realData = data as! NSData
            realData = JSCJSONManager.encondeDataUTF8(realData)
            resultDictionary =  JSCJSONManager.JSONObjectWithData(realData)
        }
        else {
            
            resultDictionary =  data as? Dictionary <String, AnyObject>
        }
        
        return resultDictionary!
    }
    
    /**
     Applies UTF8 encoding to the data
     
     - Parameter Data without UTF8 encoding
     
     - Returns: data with UTF8 enconding
     */
    class func encondeDataUTF8(data: NSData) -> NSData {
        
        let theContent = NSString.init(data: data, encoding:NSUTF8StringEncoding)
        
        let newJsonString = theContent!.stringByReplacingOccurrencesOfString("\t", withString:"\\t")
        
        let resultData = newJsonString.dataUsingEncoding(NSUTF8StringEncoding)
        
        return resultData!
    }
    
    /**
     Reads the deserialised data in a NSdictionary
     
     - Parameter data to process
     
     - Returns: Dictionary with the processed information
     */
    class func JSONObjectWithData(data: NSData) -> Dictionary <String, AnyObject>? {
        
        var fetchedDataDictionary: Dictionary <String, AnyObject>?
        
        do {
            
            try fetchedDataDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Dictionary <String, AnyObject>
        }
        catch {
            
            let nserror = error as NSError
            
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return fetchedDataDictionary!
    }
}