//
//  JSCPostPageParser.m
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCPostPageParser.h"

#import "JSCPostPage.h"
#import "JSCPost.h"
#import "JSCPostParser.h"
#import "CDSServiceManager.h"

/**
 PostPage JSON Keys.
 */
static NSString * const kJSCPosts = @"posts";
static NSString * const kJSCData = @"data";
static NSString * const kJSCPagination = @"pagination";
static NSString * const kJSCcurrentPage = @"current_page";
static NSString * const kJSCNextPage = @"next_page";

@implementation JSCPostPageParser

#pragma mark - Page

- (JSCPostPage *)parsePage:(NSDictionary *)pageDictionary
{
    NSArray *postsDictionaries = pageDictionary[kJSCPosts][kJSCData];
    
    JSCPostPage *page = nil;
    
    if (postsDictionaries.count > 0)
    {
        JSCPostParser *parser = [JSCPostParser parserWithContext:self.managedContext];
        
        NSArray *parsedPosts = [parser parsePosts:postsDictionaries];
        
        for (JSCPost *post in parsedPosts)
        {
            if (!post.page)
            {
                if (!page)
                {
                    NSDictionary *metaDictionary = pageDictionary[kJSCPosts][kJSCPagination];
                    
                    page = [self parseMetaDictionary:metaDictionary];
                }
                
                post.page = page;
            }
        }
    }
    else
    {
        NSDictionary *metaDictionary = pageDictionary[kJSCPosts][kJSCPagination];
        
        page = [self parseMetaDictionary:metaDictionary];
    }
    
    return page;
}

#pragma mark - Meta

- (JSCPostPage *)parseMetaDictionary:(NSDictionary *)metaDictionary
{
    JSCPostPage *page = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JSCPostPage class])
                                                      inManagedObjectContext:self.managedContext];
    
    page.nextPageRequestPath = JSCValueOrDefault(metaDictionary[kJSCNextPage], nil);
    page.index = JSCValueOrDefault(metaDictionary[kJSCcurrentPage], nil);
    
    return page;
}

@end
