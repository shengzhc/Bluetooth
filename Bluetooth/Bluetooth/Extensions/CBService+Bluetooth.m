//
//  CBService+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/28/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "CBService+Bluetooth.h"

@implementation CBService (Bluetooth)

- (CBCharacteristic *)characteristicWithCharacteristicUUIDString:(NSString *)characteristicUUIDString
{
    CBCharacteristic *characteristic = nil;
    
    for (CBCharacteristic *c in self.characteristics) {
        if ([c.UUID.UUIDString isEqualToString:characteristicUUIDString]) {
            characteristic = c;
            break;
        }
    }
    
    return characteristic;
}

@end
