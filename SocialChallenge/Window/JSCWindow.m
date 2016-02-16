//
//  JSCWindow.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCWindow.h"

@interface JSCWindow ()

/**
 Adds the spash image view as a subview.
 */
- (void)showSplashScreen;

/**
 Adds the spash View Controller as a subview.
 Hide and remove View Controller from superview.
 */
- (void)showSplashViewController;

@end

@implementation JSCWindow

#pragma mark - SuperClass

- (void)makeKeyAndVisible
{
    [super makeKeyAndVisible];
    [self showSplashScreen];
}

#pragma mark - Show

- (void)showSplashViewController
{
    [self addSubview:self.splashViewController.view];
}

- (void)showSplashScreen
{
    [self showSplashViewController];
}

#pragma mark - Hide

- (void)hideSplashScreen
{
    [UIView animateWithDuration:0.3
                     animations:^
     {
         self.splashViewController.view.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         [self.splashViewController.view removeFromSuperview];
         self.splashViewController = nil;
     }];
}

@end