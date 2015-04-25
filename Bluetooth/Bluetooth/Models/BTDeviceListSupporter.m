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
            BTBranchBlock *branch = [[BTBranchBlock alloc] initWithBranchNumber:index temperature:rand()%40+10];
            [self.branches addObject:branch];
        }
    }
    return self;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.branches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[BTTableViewCellFactory shareInstance] tableView:tableView withBTCellType:kBTDeviceListTableViewCell withIndexPath:indexPath];
    
    if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
        BTBranchBlock *branch = self.branches[indexPath.row];
        BTDeviceListTableViewCell *deviceListCell = (BTDeviceListTableViewCell *)cell;
        deviceListCell.nameLabel.text = [NSString stringWithFormat:@"Branch_%@", @(branch.branchNumber)];

        NSMutableAttributedString *currentTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(branch.branchTemperature).stringValue attributes:[BTDeviceListTableViewCell currentTemperatureTextAttributes]];
        [currentTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString celsius] attributes:[BTDeviceListTableViewCell currentTemperatureDegreeAttributes]]];
        deviceListCell.currentTemperatureLabel.attributedText = currentTemperatureString;

        NSMutableAttributedString *targetTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(branch.branchTargetTemperature).stringValue attributes:[BTDeviceListTableViewCell targetTemperatureTextAttributes]];
        [targetTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString celsius] attributes:[BTDeviceListTableViewCell targetTemperatureDegreeAttributes]]];
        deviceListCell.targetTemperatureLabel.attributedText = targetTemperatureString;
    }
    
    return cell;
}

@end
