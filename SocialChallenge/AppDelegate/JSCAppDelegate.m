//
//  JSCAppDelegate.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import "JSCAppDelegate.h"

#import <CoreDataServices/CDSServiceManager.h>
#import <EasyDownloadSession/EDSDownloadSession.h>
#import <CoreDataServices/NSManagedObjectContext+CDSDelete.h>

#import "JSCOperationCoordinator.h"
#import "NSOperationQueue+JSCOperationScheduler.h"
#import "JSCWindow.h"
#import "JSCSplashViewController.h"
#import "JSCRootNavigationController.h"
#import "JSCFileManager.h"

@interface JSCAppDelegate ()

@end

@implementation JSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [EDSDownloadSession downloadSession].maxDownloads = @(4);
    
    [[CDSServiceManager sharedInstance] setupModelURLWithModelName:@"SocialChallenge"];
    
    NSOperationQueue *networkDataOperationQueue = [[NSOperationQueue alloc] init];
    
    networkDataOperationQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    [[JSCOperationCoordinator sharedInstance] registerScheduler:networkDataOperationQueue
                                            schedulerIdentifier:kJSCNetworkDataOperationSchedulerTypeIdentifier];
    
    NSOperationQueue *localDataOperationQueue = [[NSOperationQueue alloc] init];
    
    localDataOperationQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    [[JSCOperationCoordinator sharedInstance] registerScheduler:localDataOperationQueue
                                            schedulerIdentifier:kJSCLocalDataOperationSchedulerTypeIdentifier];
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.clipsToBounds = NO;
    
    /**
     For the sake of the exercise, I will get rid of everything on startup
     */
    [[CDSServiceManager sharedInstance].mainManagedObjectContext cds_deleteEntriesForEntityClass:[JSCPost class]];
    [[CDSServiceManager sharedInstance].mainManagedObjectContext cds_deleteEntriesForEntityClass:[JSCPostPage class]];
    
    [JSCFileManager deleteDataFromDocumentDirectoryWithPath:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[CDSServiceManager sharedInstance] saveMainManagedObjectContext];
}

#pragma mark - Window

- (JSCWindow *)window
{
    if (!_window)
    {
        _window = [[JSCWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        
        _window.splashViewController = [[JSCSplashViewController alloc] init];
        _window.rootViewController = self.navigationController;
        
        _window.windowLevel = 1.2f;
    }
    
    return _window;
}

#pragma mark - Root

- (UINavigationController *)navigationController
{
    if (!_navigationController)
    {
        _navigationController = [[JSCRootNavigationController alloc] init];
        [_navigationController setNavigationBarHidden:YES];
    }
    
    return _navigationController;
}

@end
