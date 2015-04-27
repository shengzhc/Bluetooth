//
//  BTTableViewCellFactory.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kDefault = 0,
    kBTDeviceListTableViewCell = 1,
    kBTDegreeUnitSwitchCell = 2,
    kBTLabelTableViewCell = 3
} BTTableViewCellType;

@interface BTTableViewCellFactory : NSObject

+ (BTTableViewCellFactory *)shareInstance;
- (UITableViewCell *)tableView:(UITableView *)tableView withBTCellType:(BTTableViewCellType)type withIndexPath:(NSIndexPath *)indexPath;

@end

