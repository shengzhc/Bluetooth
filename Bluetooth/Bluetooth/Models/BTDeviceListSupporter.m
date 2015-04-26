//
//  BTDeviceListDataSource.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListSupporter.h"
#import "BTDeviceListTableViewCell.h"

@interface BTDeviceListSupporter ()
@property (strong, nonatomic) NSMutableArray *branches;
@end

@implementation BTDeviceListSupporter

- (instancetype)init
{
    if (self = [super init]) {
        self.branches = [NSMutableArray new];
        for (NSUInteger index=1; index <= 5; index++) {
            BTBranchBlock *branch = [[BTBranchBlock alloc] initWithBranchNumber:index temperature:arc4random()%20 + 10];
            [self.branches addObject:branch];
        }
    }
    return self;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.branches.count;
    } else if (section == 1) {
        return self.branches.count == 0 ? 0 : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDeviceListTableViewCell withIndexPath:indexPath];
        if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
            BTBranchBlock *branch = self.branches[indexPath.row];
            BTDeviceListTableViewCell *deviceListCell = (BTDeviceListTableViewCell *)cell;
            deviceListCell.nameLabel.text = [NSString stringWithFormat:@"Branch_%@", @(branch.branchNumber)];
            
            BOOL isCelsius = [BTAppState sharedInstance].degreeUnitType == kBTDegreeCelsius;
            
            NSNumber *currentTemperature = isCelsius ? @(branch.branchTemperature) : [NSNumber convertNumberToFahrenheit:@(branch.branchTemperature)];
            NSMutableAttributedString *currentTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(currentTemperature.integerValue).stringValue attributes:[BTDeviceListTableViewCell currentTemperatureTextAttributes]];
            [currentTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:(isCelsius ? [NSString celsius] : [NSString fahrenheit]) attributes:[BTDeviceListTableViewCell currentTemperatureDegreeAttributes]]];
            deviceListCell.currentTemperatureLabel.attributedText = currentTemperatureString;

            NSString *targetTemperatureText = @"--";
            if (branch.branchTargetTemperature != NSUIntegerMax) {
                targetTemperatureText = isCelsius ? @(branch.branchTargetTemperature).stringValue : @([NSNumber convertNumberToFahrenheit:@(branch.branchTargetTemperature)].integerValue).stringValue;
            }
            
            NSMutableAttributedString *targetTemperatureString = [[NSMutableAttributedString alloc] initWithString:targetTemperatureText attributes:[BTDeviceListTableViewCell targetTemperatureTextAttributes]];
            [targetTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:(isCelsius ? [NSString celsius] : [NSString fahrenheit]) attributes:[BTDeviceListTableViewCell targetTemperatureDegreeAttributes]]];
            deviceListCell.targetTemperatureLabel.attributedText = targetTemperatureString;
        }
    } else if (indexPath.section == 1) {
        cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDegreeUnitSwitchCell withIndexPath:indexPath];
    }
    
    return cell;
}

@end
