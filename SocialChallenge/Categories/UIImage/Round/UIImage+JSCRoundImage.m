//
//  UIImage+JSCRoundImage.m
//  SocialChallenge
//
//  Created by Javier Laguna on 02/03/2016.
//
//

#import "UIImage+JSCRoundImage.h"

@implementation UIImage (JSCRoundImage)

#pragma mark - Mask

+ (UIImage *)jsc_roundImage:(UIImage *)image
{
    @autoreleasepool
    {
        CGFloat deviceScale = [UIScreen mainScreen].scale;
        CGFloat finalDimension = ceilf(kJSCPostAvatardimension * deviceScale);
        
        CGSize contextSize = CGSizeMake(finalDimension,
                                        finalDimension);
        CGContextRef context;
        
        // Create circle mask to use for the rounding:
        CGImageRef imageMask = nil;
        UIImage *circleMask = nil;
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               NO,
                                               0.0f);
        
        context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        
        // Draw the white box that'll be filtered out by the mask:
        CGContextSetFillColorWithColor(context,
                                       [UIColor whiteColor].CGColor);
        
        CGRect contextRect = CGRectMake(0.0f,
                                        0.0f,
                                        contextSize.width,
                                        contextSize.height);
        
        CGContextFillRect(context,
                          contextRect);
        
        // Draw the black circle you'll see "through" via the mask, we have to inset the circle
        // a little so that it's very edges aren't cut off:
        CGRect elipseRect = CGRectInset(contextRect,
                                        1.0f,
                                        1.0f);
        
        CGContextSetFillColorWithColor(context,
                                       [UIColor blackColor].CGColor);
        
        CGContextFillEllipseInRect(context,
                                   elipseRect);
        
        circleMask = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRef maskReference = circleMask.CGImage;
        imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                      CGImageGetHeight(maskReference),
                                      CGImageGetBitsPerComponent(maskReference),
                                      CGImageGetBitsPerPixel(maskReference),
                                      CGImageGetBytesPerRow(maskReference),
                                      CGImageGetDataProvider(maskReference),
                                      NULL, // Decode is null
                                      YES); // Should interpolate
        
        // Combine the mask & the preview image:
        CGImageRef maskedReference = CGImageCreateWithMask(image.CGImage, imageMask);
        UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
        CGImageRelease(maskedReference);
        CGImageRelease(imageMask);
        
        // Draw the actual final image:
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               NO,
                                               0.0f);
        
        [maskedImage drawInRect:CGRectMake(0.0f,
                                           0.0f,
                                           finalDimension,
                                           finalDimension)];
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return finalImage;
    }
}

@end
