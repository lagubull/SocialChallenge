//
//  JSCPostParser.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 06/03/2016.
//
//

import Foundation
import CoreData

/**
Post JSON Keys.
*/
let kJSCPostId = "id" as String
let kJSCLikeCount = "like_count" as String
let kJSCCommentCount = "comment_count" as String
let kJSCContent = "content" as String
let kJSCUser = "user" as String
let kJSCAvatar = "avatar" as String
let kJSCFirstName = "first_name" as String
let kJSCLastName = "last_name" as String
let kJSCCreatedAt = "created_at" as String

/**
 Extracts a Post.
 */
@objc(JSCPostParser)

class JSCPostParser: JSCParser {
    
    //MARK: Posts
    
    /**
    Parse array of posts.
    
    - Parameter postsDictionaries: array of dictionaries with posts.
    
    - Returns: NSArray of posts.
    */
    func parsePosts(postsDictionaries: Array <Dictionary <String, AnyObject>>) -> Array <JSCPost> {
        
        var posts: Array <JSCPost> = []
        
        for postDictionary in postsDictionaries {
            
            let post = self.parsePost(postDictionary)
            
            posts.append(post)
        }
        
        return posts
    }
    
    //MARK: Post
    
    /**
    Parse Post.
    
    - Parameter postDictionary: JSON containing a post.
    
    - Returns: JSCPostPage instance that was parsed.
    */
    func parsePost(postDictionary: Dictionary <String, AnyObject>) -> JSCPost! {
        
        var post: JSCPost!
        
        guard let managedObjectContext = self.managedObjectContext else { return post }
        
        if postDictionary[kJSCPostId] != nil {
            
            let postId = "\(postDictionary[kJSCPostId]!)"
            
            post = JSCPost.fetchPostWithId(postId, managedObjectContext: managedObjectContext)
            
            if post == nil {
                
                post = NSEntityDescription.cds_insertNewObjectForEntityForClass(JSCPost.self, inManagedObjectContext: self.managedObjectContext) as!JSCPost
                post.postId = postId
            }
            
            let dateFormatter = NSDateFormatter.jsc_dateFormatter() as NSDateFormatter
            
            post.createdAt = JSCValueOrDefault(dateFormatter.dateFromString("\(postDictionary[kJSCCreatedAt])"), defaultValue: post.createdAt) as? NSDate
            
            post.likeCount = JSCValueOrDefault(postDictionary[kJSCLikeCount], defaultValue: post.likeCount) as? NSNumber
            
            post.content = JSCValueOrDefault(postDictionary[kJSCContent], defaultValue: post.content)  as? String
            
            post.commentCount = JSCValueOrDefault(postDictionary[kJSCCommentCount], defaultValue: post.commentCount)  as? NSNumber
            
            if let userDictionary = postDictionary[kJSCUser] {
                
                post.userAvatarRemoteURL = JSCValueOrDefault(userDictionary[kJSCAvatar], defaultValue: post.userAvatarRemoteURL) as? String
                post.userFirstName = JSCValueOrDefault(userDictionary[kJSCFirstName], defaultValue: post.userFirstName) as? String
                post.userLastName = JSCValueOrDefault(userDictionary[kJSCLastName], defaultValue: post.userLastName) as? String
            }
            
        }
        
        return post;
    }
}
      