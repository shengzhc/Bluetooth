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
//@property (strong, nonatomic) NSMutableArray *branches;
@property (strong, nonatomic) BTDataPackage *dataPackage;
@end

@implementation BTDeviceListSupporter

- (instancetype)init
{
    if (self = [super init]) {
        Byte bytes[] = {0x01, 0x10, 0x02, 0x11, 0x03, 0x12, 0x04, 0x13, 0x05, 0x14};
        NSData *testData = [NSData dataWithBytes:bytes length:sizeof(bytes)/sizeof(Byte)];
//        self.dataPackage = [testData dataPackage];
    }
    return self;
}

- (BTBranchBlock *)branchWithIndex:(NSUInteger)index
{
    if (index >= self.dataPackage.branches.count) {
        return nil;
    }
    
    return self.dataPackage.branches[index];
}

- (BTBranchBlock *)branchWithBranchNumber:(NSUInteger)branchNumber
{
    id branchBlock = nil;
    for (BTBranchBlock *branch in self.dataPackage.branches) {
        if (branch.branchNumber == branchNumber) {
            branchBlock = branch;
        }
    }
    return branchBlock;
}

- (void)updateBranchWithBranchNumber:(NSUInteger)branchNumber updatedBranch:(BTBranchBlock *)branch
{
    BTBranchBlock *originalBranch = [self branchWithBranchNumber:branchNumber];
    originalBranch.branchTemperature = branch.branchTemperature;
    originalBranch.branchTargetTemperature = branch.branchTargetTemperature;
    [[BTBluetoothManager sharedInstance] sendDataPackage:self.dataPackage withSender:self];

    NSUInteger index = [self.dataPackage.branches indexOfObject:originalBranch];
    if (index != NSNotFound) {
        __block NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
}

#pragma mark BTBluetoothManagerDelegate
- (void)bluetoothManager:(BTBluetoothManager *)bluetoothManager didReceiveDataPackage:(BTDataPackage *)dataPackage
{
    for (BTBranchBlock *newBranch in dataPackage.branches) {
        BTBranchBlock *oldBranch = [self branchWithBranchNumber:newBranch.branchNumber];
        if (oldBranch) {
            newBranch.branchTargetTemperature = oldBranch.branchTargetTemperature;
        }
    }
    
    self.dataPackage = dataPackage;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataPackage.branches.count;
    } else if (section == 1) {
        return self.dataPackage.branches.count == 0 ? 0 : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDeviceListTableViewCell withIndexPath:indexPath];
        if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
            BTBranchBlock *branch = self.dataPackage.branches[indexPath.row];
            BTDeviceListTableViewCell *deviceListCell = (BTDeviceListTableViewCell *)cell;
            deviceListCell.nameLabel.text = branch.branchName;
            
            NSNumber *currentTemperature = [BTAppState sharedInstance].isCelsius ? @(branch.branchTemperature) : [NSNumber convertNumberToFahrenheit:@(branch.branchTemperature)];
            NSMutableAttributedString *currentTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(currentTemperature.integerValue).stringValue attributes:[BTDeviceListTableViewCell currentTemperatureTextAttributes]];
            [currentTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:([BTAppState sharedInstance].isCelsius ? [NSString celsius] : [NSString fahrenheit]) attributes:[BTDeviceListTableViewCell currentTemperatureDegreeAttributes]]];
            deviceListCell.currentTemperatureLabel.attributedText = currentTemperatureString;

            NSString *targetTemperatureText = @"--";
            if (branch.branchTargetTemperature != NSUIntegerMax) {
                NSNumber *targetTemperature = [BTAppState sharedInstance].isCelsius ? @(branch.branchTargetTemperature) : [NSNumber convertNumberToFahrenheit:@(branch.branchTargetTemperature)];
                targetTemperatureText = @(targetTemperature.integerValue).stringValue;
            }
            
            NSMutableAttributedString *targetTemperatureString = [[NSMutableAttributedString alloc] initWithString:targetTemperatureText attributes:[BTDeviceListTableViewCell targetTemperatureTextAttributes]];
            [targetTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:([BTAppState sharedInstance].isCelsius ? [NSString celsius] : [NSString fahrenheit]) attributes:[BTDeviceListTableViewCell targetTemperatureDegreeAttributes]]];
            deviceListCell.targetTemperatureLabel.attributedText = targetTemperatureString;
        }
    } else if (indexPath.section == 1) {
        cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDegreeUnitSwitchCell withIndexPath:indexPath];
    }
    
    return cell;
}

@end
