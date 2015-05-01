//
//  BTDeviceListTableViewCell.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListTableViewCell.h"

@interface BTDeviceListTableViewCell ()

@end

@implementation BTDeviceListTableViewCell

+ (NSDictionary *)currentTemperatureTextAttributes
{
    static NSDictionary *currentTemperatureTextAttributes = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTemperatureTextAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:36.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    });
    
    return currentTemperatureTextAttributes;
}

+ (NSDictionary *)currentTemperatureDegreeAttributes
{
    static NSDictionary *currentTemperatureDegreeAttributes = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentTemperatureDegreeAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:16], NSForegroundColorAttributeName: [UIColor whiteColor], (NSString *)kCTSuperscriptAttributeName: @(2.0)};
    });
    
    return currentTemperatureDegreeAttributes;
}

+ (NSDictionary *)targetTemperatureTextAttributes
{
    static NSDictionary *targetTemperatureTextAttributes = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        targetTemperatureTextAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:18], NSForegroundColorAttributeName: [UIColor bambooColor]};
    });
    
    return targetTemperatureTextAttributes;
}

+ (NSDictionary *)targetTemperatureDegreeAttributes
{
    static NSDictionary *targetTemperatureDegreeAttributes = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        targetTemperatureDegreeAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:12], NSForegroundColorAttributeName: [UIColor bambooColor], (NSString *)kCTSuperscriptAttributeName: @(0.8)};
    });
    
    return targetTemperatureDegreeAttributes;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.font = [UIFont bluetoothFontOfSize:22.0];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    longPressGestureRecognizer.minimumPressDuration = 0.25f;
    [self.contentView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(deviceListTableViewCell:handleLongPressGestureRecognizer:)]) {
        [self.delegate deviceListTableViewCell:self handleLongPressGestureRecognizer:gestureRecognizer];
    }
}

@end
