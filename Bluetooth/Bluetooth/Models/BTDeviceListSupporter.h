//
//  BTDeviceListDataSource.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTDeviceListSupporter;
@protocol BTDeviceListSupporterDelegate <NSObject>
@end

@interface BTDeviceListSupporter : NSObject < UITableViewDataSource >
@property (weak, nonatomic) id < BTDeviceListSupporterDelegate > delegate;
@property (weak, nonatomic) UITableView *tableView;
@end
