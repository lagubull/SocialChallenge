//
//  UINavigationBar+JSCCustomHeight.m
//  SocialChallenge
//
//  Created by Javier Laguna on 28/02/2016.
//
//

#import "UINavigationBar+JSCCustomHeight.h"

#import "objc/runtime.h"

/**
 constant for the height.
 */
static char *const kJSCHeightKey = "Height";

@implementation UINavigationBar (JSCCustomHeight)

- (void)jsc_setHeight:(CGFloat)height
{
    objc_setAssociatedObject(self,
                             kJSCHeightKey,
                             @(height),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters

- (NSNumber *)height
{
    return objc_getAssociatedObject(self,
                                    kJSCHeightKey);
}

#pragma mark - System

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize newSize;
    
    if (self.height)
    {
        newSize = CGSizeMake(self.superview.bounds.size.width,
                             [self.height floatValue]);
    }
    else
    {
        newSize = [super sizeThatFits:size];
    }
    
    return newSize;
}

@end
