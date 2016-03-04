//
//  JSCAppDelegate.h
//  SocialChallenge
//
//  Created by Javier Laguna on 02/08/2015.
//
//

#import <UIKit/UIKit.h>

#import "JSCWindow.h"

@class JSCRootNavigationController;

@interface JSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) JSCWindow *window;

@property (nonatomic, strong) JSCRootNavigationController *navigationController;

@end
