//
//  JSCAppDelegate.h
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import <UIKit/UIKit.h>

@class JSCWindow;
@class JSCRootNavigationController;

@interface JSCAppDelegate : UIResponder <UIApplicationDelegate>

//TODO: solve warning JSCWindow incompatible with UIWindow
@property (nonatomic, strong) JSCWindow *window;

@property (nonatomic, strong) JSCRootNavigationController *navigationController;

@end

