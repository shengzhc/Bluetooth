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

+ (NSDictionary *)currentTemperatureTextAttributesWithIsActive:(BOOL)isActive
{
    if (isActive) {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:36.0], NSForegroundColorAttributeName: [UIColor whiteColor]};
    } else {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:36.0], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    }
}

+ (NSDictionary *)currentTemperatureDegreeAttributesWithIsActive:(BOOL)isActive
{
    if (isActive) {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:16], NSForegroundColorAttributeName: [UIColor whiteColor], (NSString *)kCTSuperscriptAttributeName: @(2.0)};
    } else {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:16], NSForegroundColorAttributeName: [UIColor lightGrayColor], (NSString *)kCTSuperscriptAttributeName: @(2.0)};
    }
}

+ (NSDictionary *)targetTemperatureTextAttributesWithIsActive:(BOOL)isActive
{
    if (isActive) {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:18], NSForegroundColorAttributeName: [UIColor bambooColor]};
    } else {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:18], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    }
}

+ (NSDictionary *)targetTemperatureDegreeAttributesWithIsActive:(BOOL)isActive
{
    if (isActive) {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:12], NSForegroundColorAttributeName: [UIColor bambooColor], (NSString *)kCTSuperscriptAttributeName: @(0.8)};
    } else {
        return @{NSFontAttributeName: [UIFont bluetoothFontOfSize:12], NSForegroundColorAttributeName: [UIColor lightGrayColor], (NSString *)kCTSuperscriptAttributeName: @(0.8)};
    }
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
