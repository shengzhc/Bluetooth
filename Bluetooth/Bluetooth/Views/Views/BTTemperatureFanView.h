//
//  BTTemperatureFanView.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTemperatureFanSegment : NSObject
@property (assign, nonatomic) double percentage;
@property (assign, nonatomic) double startLocation;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) NSUInteger index;
@end

IB_DESIGNABLE
@interface BTTemperatureFanView : UIView
@property (assign, nonatomic) IBInspectable NSUInteger lineWidth;
@property (assign, nonatomic) double percentage;
@property (strong, nonatomic) NSArray *segments;
@end
