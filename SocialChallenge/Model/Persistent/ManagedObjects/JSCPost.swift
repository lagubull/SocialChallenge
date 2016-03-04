//
//  JSCPost.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
//import CoreDataServices

@objc(JSCPost)

class JSCPost: NSManagedObject {
    
    // MARK: Post
    
    /**
     Retrieves a JSCPOST from DB based on ID provided.
    
     @param postId - ID of the post to be retrieved.
     @param managedObjectContext - context that should be used to access persistent store.
    
     @return JSCPOST instance or nil if POST can't be found.
    */
    class func fetchPostWithId(postId: String, managedObjectContext:NSManagedObjectContext) -> JSCPost? {
        
        let predicate = NSPredicate(format:"postId MATCHES %@", postId)
        
        var post: JSCPost?
        
        post = managedObjectContext.cds_retrieveFirstEntryForEntityClass(JSCPost.self, predicate: predicate) as? JSCPost
        
        return post
    }
    
    /**
     Retrieves a JSCPOST from DB based on ID provided, looking in the mainContext.
     
     @param postId - ID of the post to be retrieved.
     
     @return JSCPOST instance or nil if POST can't be found.
     */
    class func fetchPostWithId(postId: String) -> JSCPost? {
        
        var post: JSCPost?
        
        post = JSCPost.fetchPostWithId(postId, managedObjectContext: CDSServiceManager.sharedInstance().mainManagedObjectContext)
        
        return post
    }
    
   // MARK: UserName
    
    /**
     Convenient method to shape the user's name into the desired format.
     
     @return user's Name.
    */
    func userName()-> String {

        let lastNameFirstLetter = self.userLastName![self.userLastName!.startIndex]
        
        return "\(self.userFirstName!) \(lastNameFirstLetter).";
    }
}
