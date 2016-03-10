//
//  JSCCDSOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCCDSOperation.h"

#import <CoreDataServices/CDSServiceManager.h>

@interface JSCCDSOperation ()

/**
 Saves the parent managed context if there is changes.
 */
- (void)saveLocalContextChangesToMainContext:(id)result;

@end

@implementation JSCCDSOperation

#pragma mark - Save

- (void)saveLocalContextChangesToMainContext:(id)result
{
    [[CDSServiceManager sharedInstance].backgroundManagedObjectContext performBlockAndWait:^
     {
         NSError *localManagedObjectContentSaveError = nil;
         
         if (![[CDSServiceManager sharedInstance].backgroundManagedObjectContext save:&localManagedObjectContentSaveError])
         {
             NSLog(@"Error to saving local context: %@", [localManagedObjectContentSaveError userInfo]);
             
             [self didFailWithError:localManagedObjectContentSaveError];
         }
         else
         {
             /*
              Coredata will delay cascading deletes for performance
              so we force them to happen.
              */
             [[CDSServiceManager sharedInstance].backgroundManagedObjectContext processPendingChanges];
             
             [[CDSServiceManager sharedInstance].mainManagedObjectContext performBlockAndWait:^
              {
                  [[CDSServiceManager sharedInstance].mainManagedObjectContext save:nil];
              }];
             
             if ([result isKindOfClass:[NSError class]])
             {
                 [self didFailWithError:result];
             }
             else
             {
                 [self didSucceedWithResult:result];
             }
         }
     }];
}

- (void)saveContextAndFinishWithResult:(id)result
{
    BOOL hasChanges = [CDSServiceManager sharedInstance].backgroundManagedObjectContext.hasChanges;
    
    if (hasChanges)
    {
        [self saveLocalContextChangesToMainContext:result];
    }
    else
    {
        if ([result isKindOfClass:[NSError class]])
        {
            [self didFailWithError:result];
        }
        else
        {
            [self didSucceedWithResult:result];
        }
    }
}

@end