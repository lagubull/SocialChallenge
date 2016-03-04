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
    
    //Mark: Page
    
    /**
     Parse Page.
     
     @param pageDictionary - JSON containing a page.
     
     @return JSCPostPage instance that was parsed.
    */
    func parsePage(pageDictionary : NSDictionary) -> JSCPostPage! {
        
        let postDictionaries = pageDictionary[kJSCPosts]![kJSCData] as! NSArray
        
        var page : JSCPostPage?

        if (postDictionaries.count > 0) {
            
            let parser = JSCPostParser(context : self.managedContext)
            
            let parsedPost = parser.parsePosts(postDictionaries as [AnyObject]) as NSArray
            
            for post in parsedPost as! [JSCPost] {
                
                if (post.page == nil) {
                    
                    if (page == nil) {
                        
                        let metaDictionary = pageDictionary[kJSCPosts]![kJSCPagination] as! NSDictionary
                        
                        page = self.parseMetaDictionary(metaDictionary);
                    }
                    
                    post.page = page;
                }
                else {
                    
                    let metaDictionary = pageDictionary[kJSCPosts]![kJSCPagination] as! NSDictionary

                    page = self.parseMetaDictionary(metaDictionary)
                }
            }
        }
        
        return page
    }
    
     // Mark: Meta
    
     /**
     Parse meta data about the page.
    
     @param metaDictionary - JSON containing a page meta data.
    
     @return JSCPostPage instance that was parsed.
     */
    func parseMetaDictionary (metaDictionary : NSDictionary) -> JSCPostPage! {
        
        let page = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(JSCPostPage.self), inManagedObjectContext: self.managedContext) as! JSCPostPage
        
        page.nextPageRequestPath = JSCValueOrDefault(metaDictionary[kJSCNextPage], nil)! as? String
        page.index = JSCValueOrDefault(metaDictionary[kJSCcurrentPage], nil)! as? NSNumber
        
        return page
    }
}