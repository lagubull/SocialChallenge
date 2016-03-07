//
//  JSCPostParser.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 06/03/2016.
//
//

import Foundation

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
    
    //Mark: Posts
    
    /**
    Parse array of posts.
    
    @param postsDictionaries - array of dictionaries with posts.
    
    @return NSArray of posts.
    */
    func parsePosts(postsDictionaries : [[String : AnyObject]]) -> [JSCPost] {
        
        var posts : [JSCPost] = []
        
        for postDictionary in postsDictionaries {

            let post = self.parsePost(postDictionary)
            
            posts.append(post)
        }
        
        return posts
    }

//Mark: Post

    /**
    Parse Post.
    
    @param postDictionary - JSON containing a post.
    
    @return JSCPostPage instance that was parsed.
    */
    func parsePost (postDictionary : [String : AnyObject]) -> JSCPost! {
    
        var post : JSCPost!
        
        if ((postDictionary[kJSCPostId]) != nil) {
            
            let postId = "\(postDictionary[kJSCPostId]!)"
            
            post = JSCPost.fetchPostWithId(postId, managedObjectContext : self.managedContext)
            
            if (post == nil) {
                
                post = NSEntityDescription.insertNewObjectForEntityForName(NSStringFromClass(JSCPost.self), inManagedObjectContext : self.managedContext) as! JSCPost
                
                post.postId = postId
            }
      
            let dateFormatter = NSDateFormatter.jsc_dateFormatter() as NSDateFormatter
            
            post.createdAt = JSCValueOrDefault(dateFormatter.dateFromString("\(postDictionary[kJSCCreatedAt])"),
                post.createdAt) as? NSDate

            post.likeCount = JSCValueOrDefault(postDictionary[kJSCLikeCount], post.likeCount) as? NSNumber
            
            post.content = JSCValueOrDefault(postDictionary[kJSCContent], post.content)  as? String

            post.commentCount = JSCValueOrDefault(postDictionary[kJSCCommentCount], post.commentCount)  as? NSNumber
            
            post.userAvatarRemoteURL = JSCValueOrDefault(postDictionary[kJSCUser]![kJSCAvatar], post.userAvatarRemoteURL) as? String
            post.userFirstName = JSCValueOrDefault(postDictionary[kJSCUser]![kJSCFirstName], post.userFirstName) as? String
            post.userLastName = JSCValueOrDefault(postDictionary[kJSCUser]![kJSCLastName], post.userLastName) as? String
        }
        
        return post;
    }
}
      