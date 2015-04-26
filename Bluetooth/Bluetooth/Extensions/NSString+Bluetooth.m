//
//  NSString+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "NSString+Bluetooth.h"

@implementation NSString (Bluetooth)

+ (NSString *)fahrenheit
{
    return @"\u00B0F";
}

+ (NSString *)celsius
{
    return @"\u00B0C";
}

+ (NSString *)fahrenheitWithoutUnit
{
    return @"\u00B0";
}

+ (NSString *)celsiusWithoutUnit
{
    return @"\u00B0";
}


@end
