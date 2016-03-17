//
//  JSCPostPageParser.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 04/03/2016.
//
//

import Foundation
import CoreData
import CoreDataServices

/**
 PostPage JSON Keys.
*/
let kJSCPosts = "posts" as String
let kJSCData = "data" as String
let kJSCPagination = "pagination" as String
let kJSCcurrentPage = "current_page" as String
let kJSCNextPage = "next_page" as String

@objc(JSCPostPageParser)

/**
 Extracts a PostPage.
*/
class JSCPostPageParser: JSCParser {
    
    //MARK: Page
    
    /**
     Parse Page.
     
     - Parameter pageDictionary JSON containing a page.
     
     - Returns: JSCPostPage instance that was parsed.
    */
    func parsePage(pageDictionary: [String: AnyObject]) -> JSCPostPage! {
        
        let postDictionaries = pageDictionary[kJSCPosts]![kJSCData] as! Array <Dictionary <String, AnyObject>>
        
        var page: JSCPostPage?

        if postDictionaries.count > 0 {
            
            let parser = JSCPostParser(managedObjectContext: self.managedObjectContext)
            
            let parsedPosts = parser.parsePosts(postDictionaries) as Array <JSCPost>
            
            for post in parsedPosts {
                
                if post.page == nil {
                    
                    if page == nil {
                        
                        let metaDictionary = pageDictionary[kJSCPosts]![kJSCPagination] as! Dictionary <String, AnyObject>
                        
                        page = self.parseMetaDictionary(metaDictionary)
                    }
                    
                    post.page = page;
                }
                else {
                    
                    let metaDictionary = pageDictionary[kJSCPosts]![kJSCPagination] as! Dictionary <String, AnyObject>

                    page = self.parseMetaDictionary(metaDictionary)
                }
            }
        }
        
        return page
    }
    
     // Mark: Meta
    
     /**
     Parse meta data about the page.
    
     - Parameter metaDictionary JSON containing a page meta data.
    
     - Returns: JSCPostPage instance that was parsed.
     */
    func parseMetaDictionary(metaDictionary: Dictionary <String, AnyObject>) -> JSCPostPage! {
        
        let page = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(JSCPostPage.self), inManagedObjectContext: self.managedObjectContext) as! JSCPostPage
        
        page.nextPageRequestPath = JSCValueOrDefault(metaDictionary[kJSCNextPage], defaultValue: nil) as? String
        page.index = JSCValueOrDefault(metaDictionary[kJSCcurrentPage], defaultValue: nil) as? NSNumber
        
        return page
    }
}