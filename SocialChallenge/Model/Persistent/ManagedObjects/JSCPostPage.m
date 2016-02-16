//
//  JSCPostPage.m
//  SocialChallenge
//
//  Created by Javier Laguna on 31/01/2016.
//
//

#import "JSCPostPage.h"

#import "NSManagedObjectContext+CDSRetrieval.h"

@implementation JSCPostPage

#pragma mark - LastPage

+ (JSCPostPage *)fetchLastPageInContext:(NSManagedObjectContext *)managedObjectContext
{
    NSSortDescriptor *retrievedPagesSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index"
                                                                                   ascending:NO];
    
    NSArray *sortDescriptor = @[retrievedPagesSortDescriptor];
    
    return (JSCPostPage *) [managedObjectContext cds_retrieveFirstEntryForEntityClass:[JSCPostPage class]
                                                                            predicate:nil
                                                                      sortDescriptors:sortDescriptor];
}

@end
