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
        _minValue = 16;
        _maxValue = 38;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_maxValue - _minValue + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTLabelTableViewCell withIndexPath:indexPath];
    if ([cell isKindOfClass:[BTLabelTableViewCell class]]) {
        ((BTLabelTableViewCell *)cell).mTextLabel.textAlignment = NSTextAlignmentCenter;
        ((BTLabelTableViewCell *)cell).mTextLabel.text = @(_minValue + indexPath.row).stringValue;
    }
    
    return cell;
}

@end
