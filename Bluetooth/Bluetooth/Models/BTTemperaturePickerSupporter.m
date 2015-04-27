//
//  BTTemperaturePickerSupporter.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/26/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperaturePickerSupporter.h"

@interface BTTemperaturePickerSupporter ()
@end

@implementation BTTemperaturePickerSupporter
{
    NSUInteger _minValue, _maxValue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _minValue = 2;
        _maxValue = 46;
    }
    return self;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return (_maxValue - _minValue) + 1;
            break;
        case 1:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return pickerView.bounds.size.width / 2.0;
            break;
        case 1:
            return pickerView.bounds.size.width / 2.0;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSMutableAttributedString *numberString = [[NSMutableAttributedString alloc] initWithString:@(_minValue+row).stringValue attributes:@{NSFontAttributeName: [UIFont bluetoothFontOfSize:26], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        return numberString;
    } else {
        if (row == 0) {
            NSMutableAttributedString *signString = [[NSMutableAttributedString alloc] initWithString:[NSString celsius] attributes:@{NSFontAttributeName: [UIFont bluetoothFontOfSize:26], NSForegroundColorAttributeName: [UIColor whiteColor]}];
            return signString;
        } else {
            NSMutableAttributedString *signString = [[NSMutableAttributedString alloc] initWithString:[NSString fahrenheit] attributes:@{NSFontAttributeName: [UIFont bluetoothFontOfSize:26], NSForegroundColorAttributeName: [UIColor whiteColor]}];
            return signString;
        }
    }
}
@end
