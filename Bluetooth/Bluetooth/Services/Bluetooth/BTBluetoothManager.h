//
//  BTBluetoothManager.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/22/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTBluetoothManager;

@protocol BTBluetoothManagerDelegate <NSObject>
@optional
- (void)bluetoothManager:(BTBluetoothManager *)bluetoothManager didReceiveDataPackage:(BTDataPackage *)dataPackage;
@end

@protocol BTBluetoothManagerPermissionDelegate <NSObject>
@end

@interface BTBluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (weak, nonatomic) id < BTBluetoothManagerDelegate > delegate;
+ (BTBluetoothManager *)sharedInstance;
- (void)start;
- (void)stop;
- (void)sendDataPackage:(BTDataPackage *)dataPackage withSender:(id)sender;
@end
