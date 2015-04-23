//
//  BTBluetoothManager.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/22/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBluetoothManager : NSObject
+ (BTBluetoothManager *)sharedInstance;
- (void)start;
- (void)stop;
@end
