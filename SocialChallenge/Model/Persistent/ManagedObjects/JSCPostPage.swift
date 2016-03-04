//
//  JSCPostPage.swift
//  
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

@objc(JSCPostPage)

class JSCPostPage: NSManagedObject {
    
    /**
    Retrieves the last page of posts stored in the context.
    
    @param context in which we want to perform the search.
    
    @return JSCPostPage - instace of the JSCPostPage class
    */
    class func fetchLastPageInContext(managedObjectContext : NSManagedObjectContext) -> JSCPostPage {
        
        let retrievedPagesSortDescriptor = NSSortDescriptor.init(key : "index", ascending : false)
        
        let sortDescriptors = [retrievedPagesSortDescriptor]
        
        return managedObjectContext.cds_retrieveFirstEntryForEntityClass(JSCPostPage.self, predicate : nil, sortDescriptors : sortDescriptors) as! JSCPostPage
    }
    
}
