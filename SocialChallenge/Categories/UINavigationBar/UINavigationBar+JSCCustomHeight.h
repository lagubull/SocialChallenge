//
//  UINavigationBar+JSCCustomHeight.h
//  SocialChallenge
//
//  Created by Javier Laguna on 28/02/2016.
//
//

#import <UIKit/UIKit.h>

/**
 Category to set the height of the Navigation Bar.
 */
@interface UINavigationBar (JSCCustomHeight)

/**
 Sets the height of the Navigation Bar.
 
 @param height the height.
 */
- (void)jsc_setHeight:(CGFloat)height;

@end
