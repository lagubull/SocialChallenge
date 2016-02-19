//
//  JSCPaginatingView.m
//  SocialChallenge
//
//  Created by Javier Laguna on 19/02/2016.
//
//

#import "JSCPaginatingView.h"

/**
 Height of the view.
 */
CGFloat const kJSCPaginatingViewHeight = 60.0f;

/**
 Vertical margin of the view from top and bottom.
 */
static CGFloat const kJSCPaginatingViewVerticalMargin = 10.0f;

/**
 Height of the spinner image view
 */
static CGFloat const kJSCPaginatingViewSpinnerHeight = 17.0f;

@interface JSCPaginatingView ()

/**
 Container view containing the label and the image view.
 */
@property (nonatomic, strong) UIView *containerView;

/**
 Label to show loading text.
 */
@property (nonatomic, strong, readwrite) UILabel *loadingLabel;

/**
 Spinner to show activity.
 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation JSCPaginatingView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addSubview:self.containerView];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self updateConstraints];
    }
    
    return self;
}

#pragma mark - Subviews

- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [UIView newAutoLayoutView];
        
        [_containerView addSubview:self.activityView];
        [_containerView addSubview:self.loadingLabel];
    }
    
    return _containerView;
}

-(UIActivityIndicatorView *)activityView
{
    if (!_activityView)
    {
        _activityView = [UIActivityIndicatorView newAutoLayoutView];
        
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _activityView.hidesWhenStopped = YES;
    }
    
    return _activityView;
}

- (UILabel *)loadingLabel
{
    if (!_loadingLabel)
    {
        _loadingLabel = [UILabel newAutoLayoutView];
        
        _loadingLabel.font = [UIFont systemFontOfSize:12.0f];
        _loadingLabel.textColor = [UIColor whiteColor];
    }
    
    return _loadingLabel;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*---------------------*/
    
    [self.activityView autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                            withInset:0.0f];
    
    [self.activityView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.activityView autoSetDimensionsToSize:CGSizeMake(kJSCPaginatingViewSpinnerHeight,
                                                              kJSCPaginatingViewSpinnerHeight)];
    
    /*---------------------*/
    
    [self.loadingLabel autoPinEdge:ALEdgeLeft
                            toEdge:ALEdgeRight
                            ofView:self.activityView
                        withOffset:10.0f];
    
    [self.loadingLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.loadingLabel autoSetDimensionsToSize:CGSizeMake(140.0f,
                                                          kJSCPaginatingViewSpinnerHeight)];
    
    /*---------------------*/
    
    [self.containerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.containerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeTop
                                         withInset:kJSCPaginatingViewVerticalMargin];
    
    [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                         withInset:kJSCPaginatingViewVerticalMargin];
    
    [self.containerView autoSetDimension:ALDimensionWidth
                                  toSize:(150.0f + kJSCPaginatingViewSpinnerHeight)];
}

#pragma mark - StartAnimating

- (void)startAnimating
{
    [self.activityView startAnimating];
}

#pragma mark - StopAnimating

- (void)stopAnimating
{
    [self.activityView stopAnimating];
}

@end
