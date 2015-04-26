//
//  UIImage+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/26/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bluetooth)

+ (UIImage *)takeSnapshotOfView:(UIView *)view;
+ (UIImage *)blurWithGPUImage:(UIImage *)sourceImage;

@end
