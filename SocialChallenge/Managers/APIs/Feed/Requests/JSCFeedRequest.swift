//
//  JSCFeedRequest.swift
//  SocialChallenge
//
//  Created by Javier Laguna on 10/03/2016.
//
//

import Foundation

/**
HTTP GET Method.
*/
let kJSCHTTPRequestMethodGet = "GET" as String!

/**
 API end point URL.
 */
let kJSCApiEndPoint = "http://unii-interview.herokuapp.com/api/v1/posts"

/**
Request to retrieve a feed.
*/
class JSCFeedRequest: NSMutableURLRequest {

    //MARK: Retrieve
    
    /**
    Creates a request for downloading the feed first page.
    
    - Returns: an instance of the class.
    */
    class func requestToRetrieveFeed () -> JSCFeedRequest {
        
        return self.requestToRetrieveFeedNexPageWithURL(kJSCApiEndPoint)
    }
    
    /**
    Creates a request for downloading a page of content.

    - Parameter URL: URL to download the content from.
    
    - Returns: an instance of the class.
    */
    class func requestToRetrieveFeedNexPageWithURL(URL: String) -> JSCFeedRequest {
    
        let request = self.init() as JSCFeedRequest
        
        request.HTTPMethod = kJSCHTTPRequestMethodGet
        
        request.URL = NSURL.init(string: URL)
        
        return request
    }
}