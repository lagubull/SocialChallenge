//
//  AppDelegate.swift
//  testingAPPdelegate
//
//  Created by Javier Laguna on 12/03/2016.
//  Copyright © 2016 Javier Laguna. All rights reserved.
//

import UIKit

import CoreDataServices
import EasyDownloadSession

/**
Constant to define the stack for API calls.
*/
let kJSCApiDownloadStack: String = "kJSCApiDownloadStack"

/**
Constant to define the stack for media download calls.
*/
let kJSCMediaDownloadStack: String = "kJSCMediaDownloadStack"


/**
 Inline function for printing log messages only while on debug configuration.
*/
func DLog(message: String, function: String = __FUNCTION__) {
    #if DEBUG
        print("\(function): \(message)")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Root
    
    lazy var navigationController : UINavigationController = {
        
        let _navigationController = JSCRootNavigationController.init()
        _navigationController.setNavigationBarHidden(true, animated: false)
        
        return _navigationController
    }()
    
    //MARK: Window
    lazy var window : UIWindow? = {
        
        let window = JSCWindow.init(frame: UIScreen.mainScreen().bounds)
        window.tintAdjustmentMode = .Normal
        
        window.splashViewController = JSCSplashViewController.init()
        window.rootViewController = self.navigationController
        
        window.windowLevel = 1.2
        
        return window
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        CDSServiceManager.sharedInstance().setupModelURLWithModelName("SocialChallenge")
        
        self.window!.backgroundColor = .clearColor()
        self.window!.clipsToBounds = false
        
        /**
        For the sake of the exercise, I will get rid of everything on startup
        */
        CDSServiceManager.sharedInstance().mainManagedObjectContext.cds_deleteEntriesForEntityClass(JSCPost.self)
        CDSServiceManager.sharedInstance().mainManagedObjectContext.cds_deleteEntriesForEntityClass(JSCPostPage.self)
        
        JSCFileManager.deleteDataFromDocumentDirectoryWithPath(nil)
        
        self.registerQueues()
        self.registerStacks()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: RegisterQueues
    
    /**
    Registering operation queues.
    */
    func registerQueues() {
        
        let localDataOperationQueue = NSOperationQueue()
        
        localDataOperationQueue.qualityOfService = .UserInitiated
        JSCOperationCoordinator.sharedInstance.registerQueue(localDataOperationQueue, schedulerIdentifier: kJSCLocalDataOperationSchedulerTypeIdentifier)
    }
    
    //MARK: RegisterStacks
    
    /**
    Registering operation stacks.
    */
    func registerStacks() {
        
        let apiStack = EDSStack()
        
        apiStack.maxDownloads = 10
        
        EDSDownloadSession.sharedInstance().registerStack(apiStack, stackIdentifier:kJSCApiDownloadStack)
        
        let mediaStack = EDSStack()
        
        mediaStack.maxDownloads = 4;
        
        EDSDownloadSession.sharedInstance().registerStack(mediaStack, stackIdentifier:kJSCMediaDownloadStack)
    }
}
