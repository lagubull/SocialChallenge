//
//  JSCEmptyView.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import "JSCEmptyView.h"

@interface JSCEmptyView ()

/**
 Label for displaying a customizable message.
 */
@property (nonatomic, strong, readwrite) UILabel *messageLabel;

@end

@implementation JSCEmptyView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.messageLabel];
    }
    
    return self;
}

#pragma mark - Subviews

-(UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [UILabel newAutoLayoutView];
        
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
    
    return _messageLabel;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [self.messageLabel autoCenterInSuperview];
    
    /*------------------*/
    
    [super updateConstraints];
}

@end