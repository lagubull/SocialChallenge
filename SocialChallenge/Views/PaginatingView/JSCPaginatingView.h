//
//  JSCPaginatingView.h
//  SocialChallenge
//
//  Created by Javier Laguna on 19/02/2016.
//
//

#import <UIKit/UIKit.h>

/**
 Height of this view.
 */
extern CGFloat const kJSCPaginatingViewHeight;

/**
 Loading view for paginating on feed.
 */
@interface JSCPaginatingView : UIView

/**
 Label to show loading text.
 */
@property (nonatomic, strong, readonly) UILabel *loadingLabel;

/**
 Handles starting the animation of loading indicator.
 */
- (void)startAnimating;

/**
 Handles stopping the animation of loading indicator.
 */
- (void)stopAnimating;

@end