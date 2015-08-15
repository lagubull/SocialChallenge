//
//  JSCCDSServiceManager.m
//  SocialChallenge
//
//  Created by Javier Laguna on 06/08/2015.
//
//

#import "JSCCDSServiceManager.h"

static JSCCDSServiceManager *sharedInstance = nil;

@interface JSCCDSServiceManager ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation JSCCDSServiceManager

#pragma mark - SharedInstance

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "unii.SocialChallenge" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (!_managedObjectModel)
    {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SocialChallenge"
                                                  withExtension:@"momd"];
        
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (!_persistentStoreCoordinator)
    {
        // Create the coordinator and store
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SocialChallenge.sqlite"];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:nil
                                                               error:&error])
        {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
                                        code:9999
                                    userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (!_managedObjectContext)
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        
        if (!coordinator)
        {
            return nil;
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

#pragma mark - Managed Object Context

- (void)saveManagedObjectContext
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] &&
        ![self.managedObjectContext save:&error])
    {
        NSLog(@"Couldn't save context: %@", [error userInfo]);
    }
    else
    {
        //Force context to process pending changes as
        //cascading deletes may not be immediatly applied by coredata.
        [self.managedObjectContext processPendingChanges];
    }
}

@end
