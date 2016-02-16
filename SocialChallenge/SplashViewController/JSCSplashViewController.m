//
//  JSCSplashViewController.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCSplashViewController.h"

#import "JSCWindow.h"

@interface JSCSplashViewController ()

/**
 Dissmises the view countroller
 */
- (void)hide;

@end

@implementation JSCSplashViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: show something meaningful
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    //TODO: show something meaningful
    [UIView animateWithDuration:2.0
                     animations:^
     {
         self.view.backgroundColor = [UIColor whiteColor];
     }
                     completion:^(BOOL finished)
     {
         [self hide];
     }];
}

#pragma mark - Hide

- (void)hide
{
    JSCWindow *splashWindow = (JSCWindow *)[UIApplication sharedApplication].delegate.window;
    
    [splashWindow hideSplashScreen];
}

@end
