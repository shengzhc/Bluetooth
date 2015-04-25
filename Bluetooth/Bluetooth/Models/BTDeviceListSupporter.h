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
@optional
- (void)handleLongPressWithSender:(id)sender;
@end

@interface BTDeviceListSupporter : NSObject < UITableViewDataSource, UITableViewDelegate >
@property (weak, nonatomic) id < BTDeviceListSupporterDelegate > delegate;

@end
