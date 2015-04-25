//
//  BTDeviceListDataSource.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListDataSource.h"
#import "BTDeviceListTableViewCell.h"

@implementation BTDeviceListDataSource

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDeviceListTableViewCell withIndexPath:indexPath];
    
    if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
        BTDeviceListTableViewCell *deviceListCell = (BTDeviceListTableViewCell *)cell;
        deviceListCell.nameLabel.text = [NSString stringWithFormat:@"Branch_%@", @(indexPath.row)];
        
        NSMutableAttributedString *currentTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(rand()%40+10).stringValue attributes:[BTDeviceListTableViewCell currentTemperatureTextAttributes]];
        [currentTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString celsius] attributes:[BTDeviceListTableViewCell currentTemperatureDegreeAttributes]]];
        deviceListCell.currentTemperatureLabel.attributedText = currentTemperatureString;

        NSMutableAttributedString *targetTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(rand()%40+10).stringValue attributes:[BTDeviceListTableViewCell targetTemperatureTextAttributes]];
        [targetTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString celsius] attributes:[BTDeviceListTableViewCell targetTemperatureDegreeAttributes]]];
        deviceListCell.targetTemperatureLabel.attributedText = targetTemperatureString;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
