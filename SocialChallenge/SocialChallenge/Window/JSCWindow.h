//
//  JSCWindow.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <UIKit/UIKit.h>

@class FSNSplashViewController;

@interface JSCWindow : UIWindow

@property (nonatomic, strong) UIViewController *splashViewController;

/**
 Hide the Splash image / video with an animation.
 */
- (void)hideSplashScreen;

@end