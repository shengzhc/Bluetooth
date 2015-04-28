//
//  BTDeviceListDataSource.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTDeviceListSupporter;

@interface BTDeviceListSupporter : NSObject < UITableViewDataSource, BTBluetoothManagerPermissionDelegate, BTBluetoothManagerDelegate >
@property (weak, nonatomic) UITableView *tableView;
- (BTBranchBlock *)branchWithIndex:(NSUInteger)index;
- (BTBranchBlock *)branchWithBranchNumber:(NSUInteger)branchNumber;
- (void)updateBranchWithBranchNumber:(NSUInteger)branchNumber updatedBranch:(BTBranchBlock *)branch;
@end
