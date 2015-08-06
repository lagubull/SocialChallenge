//
//  JSCCDSServiceManager.h
//  SocialChallenge
//
//  Created by Javier Laguna on 06/08/2015.
//
//

@interface JSCCDSServiceManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*
 Returns the global JSCCDSServiceManager instance.
 
 @return CDSServiceManager instance.
 */
+ (instancetype)sharedInstance;

- (void)saveManagedObjectContext;

- (NSURL *)applicationDocumentsDirectory;

@end
