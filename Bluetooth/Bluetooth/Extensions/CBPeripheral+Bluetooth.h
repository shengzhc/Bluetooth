//
//  CBPeripheral+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/28/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Bluetooth)

- (CBService *)serviceWithUUIDString:(NSString *)uuidString;

@end
