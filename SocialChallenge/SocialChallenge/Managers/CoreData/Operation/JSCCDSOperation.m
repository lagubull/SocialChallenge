//
//  JSCCDSOperation.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCCDSOperation.h"

#import "JSCCDSServiceManager.h"

@interface JSCCDSOperation ()

/**
 Saves the parent managed context if there is changes.
 */
- (void)saveLocalContextChangesToMainContext:(id)result;

@end

@implementation JSCCDSOperation

#pragma mark - ManagedObjectContext

- (NSManagedObjectContext *)localManagedObjectContext
{
    if (!_localManagedObjectContext)
    {
        _localManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [_localManagedObjectContext setParentContext:[JSCCDSServiceManager sharedInstance].managedObjectContext];
        
        [_localManagedObjectContext setUndoManager:nil];
        [_localManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    
    return _localManagedObjectContext;
}

#pragma mark - Save

- (void)saveLocalContextChangesToMainContext:(id)result
{
    NSError *localManagedObjectContentSaveError = nil;
    
    if (![self.localManagedObjectContext save:&localManagedObjectContentSaveError])
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
        [self.localManagedObjectContext processPendingChanges];
        [self didSucceedWithResult:result];
    }
}

- (void)saveContextAndFinishWithResult:(id)result
{
    BOOL hasChanges = self.localManagedObjectContext.hasChanges;
    
    if (hasChanges)
    {
        [self saveLocalContextChangesToMainContext:result];
    }
    else
    {
        [self didSucceedWithResult:result];
    }
}

@end