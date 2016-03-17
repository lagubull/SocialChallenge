//
//  JSCWindow.h
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import <UIKit/UIKit.h>

/**
 Custom Window, used to show a custom splash animation.
 */
 @interface JSCWindow : UIWindow

/**
 View controller to show when the app starts up.
 */
@property (nonatomic, strong) UIViewController *splashViewController;

/**
 Hide the Splash image / video with an animation.
 */
- (void)hideSplashScreen;

@end