//
//  JSCParser.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 07/03/2016.
//
//

import Foundation
import CoreData

//Mark - ValueOrDefault

/**
Convenient method to check if a value is not nil and returns ir or the default
*/
@inline(__always) func JSCValueOrDefault(value : AnyObject?, defaultValue : AnyObject?) -> AnyObject?
{
    if value == nil ||
        value is NSNull {
            
            return defaultValue
    }
    
    return value
}

@objc(JSCParser)

/**
Code base for the parsers.
*/
class JSCParser: NSObject {
    
    /**
     Context for the parser to access CoreData.
     */
    var managedObjectContext = NSManagedObjectContext ()
    
    //Mark - Init
    
    /**
     Convenient initialiser the parser.
     
     @param managedContext - Context for the parser to access CoreData.
     
     @return FSNParser instance.
     */
    class func parserWithContext(managedObjectContext : NSManagedObjectContext) -> JSCParser! {
        
        let parser = JSCParser.init (managedObjectContext : managedObjectContext)
        
        return parser
    }
    
    /**
     Initialises the parser.
     
     @param managedContext - Context for the parser to access CoreData.
     
     @return FSNParser instance.
     */
    init (managedObjectContext : NSManagedObjectContext?) {
        
        self.managedObjectContext = managedObjectContext!;
    }
}
