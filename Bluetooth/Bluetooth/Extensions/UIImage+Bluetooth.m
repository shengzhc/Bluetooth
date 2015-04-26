//
//  UIImage+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/26/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UIImage+Bluetooth.h"

@implementation UIImage (Bluetooth)

+ (UIImage *)takeSnapshotOfView:(UIView *)view
{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)blurWithGPUImage:(UIImage *)sourceImage
{
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 4.0;
    return [blurFilter imageByFilteringImage: sourceImage];
}

@end
