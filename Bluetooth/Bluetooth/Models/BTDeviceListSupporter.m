//
//  BTDeviceListDataSource.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListSupporter.h"
#import "BTDeviceListTableViewCell.h"

@interface BTDeviceListSupporter () < BTDeviceListTableViewCellDelegate >
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

        NSMutableAttributedString *targetTemperatureString = [[NSMutableAttributedString alloc] initWithString:@(rand()%40+10).stringValue attributes:[BTDeviceListTableViewCell targetTemperatureTextAttributes]];
        [targetTemperatureString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString celsius] attributes:[BTDeviceListTableViewCell targetTemperatureDegreeAttributes]]];
        deviceListCell.targetTemperatureLabel.attributedText = targetTemperatureString;
        
        deviceListCell.delegate = self;
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

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

#pragma mark BTDeviceListTableViewCellDelegate
- (void)deviceListTableViewCell:(BTDeviceListTableViewCell *)cell handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(handleLongPressWithSender:)]) {
        [self.delegate handleLongPressWithSender:cell];
    }
}

@end
