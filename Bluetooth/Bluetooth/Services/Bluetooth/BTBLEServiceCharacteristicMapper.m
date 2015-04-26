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
    if ([uuidString isEqualToString:@"1890"]) {
        return @[[CBUUID UUIDWithString:@"2A98"],
                 [CBUUID UUIDWithString:@"2A99"]];
    }
    return nil;
}

- (NSArray *)readCharacteristicUUIDsForServiceUUIDString:(NSString *)uuidString
{
    if ([uuidString isEqualToString:@"1890"]) {
        return @[[CBUUID UUIDWithString:@"2A98"]];
    }
    return nil;
}

- (NSArray *)writeCharacteristicUUIDsForServiceUUIDString:(NSString *)uuidString
{
    if ([uuidString isEqualToString:@"1890"]) {
        return @[[CBUUID UUIDWithString:@"2A99"]];
    }
    return nil;
}

@end
