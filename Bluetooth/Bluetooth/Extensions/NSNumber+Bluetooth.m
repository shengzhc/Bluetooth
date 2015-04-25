//
//  NSNumber+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "NSNumber+Bluetooth.h"

@implementation NSNumber (Bluetooth)

+ (NSNumber *)convertNumberToCelsius:(NSNumber *)number
{
    double num = number.doubleValue;
    num = (num - 32.0) * 5.0 / 9.0;
    return @(num);
}

+ (NSNumber *)convertNumberToFahrenheit:(NSNumber *)number
{
    double num = number.doubleValue;
    num = num * 9.0 / 5.0 + 32.0;
    return @(num);
}

@end
