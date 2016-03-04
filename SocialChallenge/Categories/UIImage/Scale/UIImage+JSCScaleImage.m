//
//  UIImage+JSCScaleImage.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import "UIImage+JSCScaleImage.h"

@implementation UIImage (JSCScaleImage)

#pragma mark - Scale

+ (UIImage *)jsc_scaleImage:(UIImage *)image
{
    UIImage *aspectFitCroppedImage = [UIImage jsc_aspectFitImage:image];
    
    // We need the device's screen scale to know what sort of fedelity to crop at
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    
    CGRect scaledRect = CGRectMake(0.0f,
                                   0.0f,
                                   (kJSCPostAvatardimension * deviceScale),
                                   (kJSCPostAvatardimension * deviceScale));
    
    // Then draw the crop into our smaller dimension size
    UIGraphicsBeginImageContext(scaledRect.size);
    [aspectFitCroppedImage drawInRect:scaledRect];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - Crop

+ (UIImage *)jsc_aspectFitImage:(UIImage *)image
{
    //Need to crop the image to ensure that when is scaled it doesn't appear stretched
    CGFloat aspectFitDimension = [UIImage jsc_aspectFitDimensionForCroppingImage:image];
    
    CGRect croppedRect = CGRectMake((image.size.width - aspectFitDimension) / 2.0f,
                                    (image.size.height - aspectFitDimension) / 2.0f,
                                    aspectFitDimension,
                                    aspectFitDimension);
    
    // Crop the portion we want
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,
                                                       croppedRect);
    
    UIImage *aspectFitCroppedImage = [UIImage imageWithCGImage:imageRef
                                                         scale:1.0f
                                                   orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return aspectFitCroppedImage;
}

+ (CGFloat)jsc_aspectFitDimensionForCroppingImage:(UIImage *)image
{
    CGFloat aspectFitDimesionForCroppingImage = image.size.width;
    
    if (image.size.width > image.size.height)
    {
        aspectFitDimesionForCroppingImage = image.size.width;
    }
    
    return aspectFitDimesionForCroppingImage;
}

@end
