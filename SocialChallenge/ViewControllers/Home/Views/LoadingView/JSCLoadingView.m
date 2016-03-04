//
//  JSCLoadingView.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import "JSCLoadingView.h"

@interface JSCLoadingView ()

/*
 Animating activity indicator.
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation JSCLoadingView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.loadingIndicator];
    }
    
    return self;
}

#pragma mark - Subviews

-(UIActivityIndicatorView *)loadingIndicator
{
    if (!_loadingIndicator)
    {
        _loadingIndicator = [UIActivityIndicatorView newAutoLayoutView];
        
        _loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        [_loadingIndicator startAnimating];
    }
    
    return _loadingIndicator;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [self.loadingIndicator autoCenterInSuperview];
    
    /*------------------*/
    
    [super updateConstraints];
}

@end
