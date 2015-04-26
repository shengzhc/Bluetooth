//
//  BTCircleView.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BTCircleView : UIView
@property (assign, nonatomic) IBInspectable NSInteger lineWidth;
@property (assign, nonatomic) IBInspectable UIColor *borderColor;
@property (assign, nonatomic) IBInspectable UIColor *fillColor;
@end
