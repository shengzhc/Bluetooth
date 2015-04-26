//
//  BTBLEServiceCharacteristicMapper.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/23/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBLEServiceCharacteristicMapper : NSObject

- (NSArray *)supportedPeripheralServices;
- (NSArray *)supportedCharacteristicForServiceUUIDString:(NSString *)uuidString;
- (NSArray *)readCharacteristicUUIDsForServiceUUIDString:(NSString *)uuidString;
- (NSArray *)writeCharacteristicUUIDsForServiceUUIDString:(NSString *)uuidString;

@end
