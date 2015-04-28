//
//  BTTemperaturePickerSupporter.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperaturePickerSupporter.h"
#import "BTLabelTableViewCell.h"

@interface BTTemperaturePickerSupporter ()

@end

@implementation BTTemperaturePickerSupporter
{
    NSInteger _minValue;
    NSInteger _maxValue;
}

- (instancetype)init
{
    if (self = [super init]) {
        _minValue = 10;
        _maxValue = 50;
        _degreeUnitType = [BTAppState sharedInstance].degreeUnitType;
    }
    return self;
}

- (NSUInteger)indexOfBranchTemperature:(double)temperature degreeUnitType:(BTDegreeUnitType)degreeUnitType
{
    if (degreeUnitType == kBTDegreeCelsius) {
        return temperature - _minValue;
    } else {
        return [NSNumber convertNumberToFahrenheit:@(temperature)].integerValue - [NSNumber convertNumberToFahrenheit:@(_minValue)].integerValue;
    }
}

- (NSNumber *)branchTemperatureAtIndex:(NSUInteger)index
{
    if (self.degreeUnitType == kBTDegreeCelsius) {
        return @(_minValue + index);
    } else {
        NSNumber *fahrenheit = @([NSNumber convertNumberToFahrenheit:@(_minValue)].doubleValue + index);
        return [NSNumber convertNumberToCelsius:fahrenheit];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_degreeUnitType == kBTDegreeCelsius) {
        return (_maxValue - _minValue + 1);
    } else {
        return ([NSNumber convertNumberToFahrenheit:@(_maxValue)].integerValue - [NSNumber convertNumberToFahrenheit:@(_minValue)].integerValue) + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTLabelTableViewCell withIndexPath:indexPath];
    if ([cell isKindOfClass:[BTLabelTableViewCell class]]) {
        ((BTLabelTableViewCell *)cell).mTextLabel.textAlignment = NSTextAlignmentCenter;
        if (_degreeUnitType == kBTDegreeCelsius) {
            ((BTLabelTableViewCell *)cell).mTextLabel.text = @(_minValue + indexPath.row).stringValue;
        } else {
            ((BTLabelTableViewCell *)cell).mTextLabel.text = @([NSNumber convertNumberToFahrenheit:@(_minValue)].integerValue + indexPath.row).stringValue;
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    return sectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionFooterHeight)];
    sectionFooter.backgroundColor = [UIColor clearColor];
    return sectionFooter;
}

@end
