//
//  UIImage+JSCScaleImage.h
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import <UIKit/UIKit.h>

/**
 Category to scale an image.
 */
@interface UIImage (JSCScaleImage)

/**
 Reduces the dimensions of an image.
 
 @param image - image to transform.
 
 @result smaller image.
 */
+ (UIImage *)jsc_scaleImage:(UIImage *)image;


@end
