//
//  JSCRootNavigationController.m
//  SocialChallenge
//
//  Created by Javier Laguna on 09/08/2015.
//
//

#import "JSCRootNavigationController.h"

#import "JSCHomeViewController.h"

@interface JSCRootNavigationController () <UINavigationControllerDelegate>

/**
 Landing view controller.
 */
@property (nonatomic, strong) JSCHomeViewController *homeViewController;

@end

@implementation JSCRootNavigationController

#pragma mark - Init

- (instancetype)init
{
    self = [super initWithRootViewController:self.homeViewController];
    
    if (self)
    {
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - Getters

- (JSCHomeViewController *)homeViewController
{
    if (!_homeViewController)
    {
        _homeViewController = [[JSCHomeViewController alloc] init];
    }
    
    return _homeViewController;
}

@end
