//
//  UIImage+JSCRoundImage.h
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import <UIKit/UIKit.h>

/**
 Category to round an image.
 */
@interface UIImage (JSCRoundImage)

/**
 Changes an image to be become a circle.
 
 @param image - image to transform.
 
 @result rounded image.
 */
+ (UIImage *)jsc_roundImage:(UIImage *)image;

@end
