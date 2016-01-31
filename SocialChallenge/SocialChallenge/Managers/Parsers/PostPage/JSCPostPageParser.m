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
#import "JSCCDSServiceManager.h"

@implementation JSCPostPageParser

#pragma mark - Page

- (JSCPostPage *)parsePage:(NSDictionary *)pageDictionary
{
    NSArray *postsDictionaries = pageDictionary[@"posts"];
    
    JSCPostPage *page = nil;
    
    if (postsDictionaries.count > 0)
    {
        JSCPostParser *parser = [JSCPostParser parser];
      //  parser.feedID = self.feedID;
        
        NSArray *parsedPosts = [parser parsePosts:postsDictionaries];
        
        for (JSCPost *post in parsedPosts)
        {
            if (!post.page)
            {
                if (!page)
                {
                    NSDictionary *metaDictionary = pageDictionary[@"meta"];
                    
                    page = [self parseMetaDictionary:metaDictionary];
                }
                
                post.page = page;
            }
        }
    }
    else
    {
        NSDictionary *metaDictionary = pageDictionary[@"meta"];
        
        page = [self parseMetaDictionary:metaDictionary];
    }
    
    return page;
}

#pragma mark - Meta

- (JSCPostPage *)parseMetaDictionary:(NSDictionary *)metaDictionary
{
//    JSCPostPage *page = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([JSCPostPage class])
//                                                           inManagedObjectContext:[JSCCDSServiceManager sharedInstance].localManagedObjectContext];
//    
    //page.nextPageRequestPath = FSNValueOrDefault(metaDictionary[@"next_href"], nil);
    
   // return page;
    
    return nil;
}



@end
