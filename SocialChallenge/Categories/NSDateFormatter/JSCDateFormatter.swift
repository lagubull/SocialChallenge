//
//  JSCDateFormatter.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 07/03/2016.
//
//

import Foundation

/**
Key to store the fateFormatter in the threads dictionary.
*/
let kJSCDateFormatterKey = "dateFormatterKey" as String

/**
 Manages our date format.
 */
extension NSDateFormatter {
    
    //MARK: DateFormatter
    
    /**
    Convenient method to create a date formatter per thread.
    
    - Returns: NSDateFormmater of the thread we are on.
    */
    class func jsc_dateFormatter() -> NSDateFormatter {
        
        if NSThread.currentThread().threadDictionary[kJSCDateFormatterKey] == nil {
            
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.timeZone = NSTimeZone.init(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_GB")
            
            NSThread.currentThread().threadDictionary[kJSCDateFormatterKey] = dateFormatter
        }
        
        return NSThread.currentThread().threadDictionary[kJSCDateFormatterKey] as! NSDateFormatter
    }
}