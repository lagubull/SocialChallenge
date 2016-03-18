//
//  JSCParser.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 07/03/2016.
//
//

import Foundation
import CoreData

//MARK: ValueOrDefault

/**
Convenient method to check if a value is not nil and returns ir or the default
*/
@inline(__always) func JSCValueOrDefault(value: AnyObject?, defaultValue: AnyObject?) -> AnyObject?
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
    
    //MARK: Init
    
    /**
    Initialises the parser.
    
    - Parameter managedContext - Context for the parser to access CoreData.
    
    - Returns: FSNParser instance.
    */
    required init(managedObjectContext: NSManagedObjectContext?) {
        
        self.managedObjectContext = managedObjectContext!;
    }
    
    //MARK: Parser
    
    /**
    Convenient initialiser the parser.
    
    - Parameter managedContext - Context for the parser to access CoreData.
    
    - Returns: FSNParser instance.
    */
    class func parserWithContext(managedObjectContext: NSManagedObjectContext) -> Self {
        
        return self.init(managedObjectContext: managedObjectContext)
    }
}