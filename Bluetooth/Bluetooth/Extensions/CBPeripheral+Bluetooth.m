//
//  CBPeripheral+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/28/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "CBPeripheral+Bluetooth.h"

@implementation CBPeripheral (Bluetooth)

- (CBService *)serviceWithUUIDString:(NSString *)uuidString
{
    for (CBService *service in self.services) {
        if ([service.UUID.UUIDString isEqualToString:uuidString]) {
            return service;
        }
    }
    
    return nil;
}

@end
