//
//  CBUUID+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/23/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "CBUUID+Bluetooth.h"

@implementation CBUUID (Bluetooth)

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[CBUUID class]]) {
        return [self.UUIDString isEqualToString:[(CBUUID *)object UUIDString]];
    }
    return [super isEqual:object];
}

@end
