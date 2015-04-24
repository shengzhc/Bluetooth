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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.nameLabel.font = [UIFont bluetoothFontOfSize:24.0];
    self.currTempLabel.font = [UIFont bluetoothFontOfSize:24.0];
    self.targetTempLabel.font = [UIFont bluetoothFontOfSize:12.0];
}

@end
