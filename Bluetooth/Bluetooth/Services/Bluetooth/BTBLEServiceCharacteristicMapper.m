//
//  BTBLEServiceCharacteristicMapper.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/23/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTBLEServiceCharacteristicMapper.h"

@implementation BTBLEServiceCharacteristicMapper

- (NSArray *)supportedPeripheralServices
{
    static NSArray *services = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        services = @[[CBUUID UUIDWithString:@"1890"]
                     ];
    });
    return services;
}

- (NSArray *)supportedCharacteristicForServiceUUIDString:(NSString *)uuidString
{
    return nil;
}

@end
