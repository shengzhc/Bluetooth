//
//  BTTableViewCellFactory.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTableViewCellFactory.h"
#import "BTDeviceListTableViewCell.h"

NSString *stringFromBTTableViewCellType(BTTableViewCellType type)
{
    switch (type) {
        case kBTDeviceListTableViewCell:
            return @"BTDeviceListTableViewCellIdentifier";
            break;
        case kDefault:
            return nil;
        default:
            break;
    }
    return nil;
}

@interface BTTableViewCellFactory ()

@end

@implementation BTTableViewCellFactory

+ (BTTableViewCellFactory *)shareInstance
{
    static BTTableViewCellFactory *factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[BTTableViewCellFactory alloc] init];
    });
    return factory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView withBTCellType:(BTTableViewCellType)type withIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = stringFromBTTableViewCellType(type);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
