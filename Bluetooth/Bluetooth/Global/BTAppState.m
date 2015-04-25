//
//  BTAppState.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTAppState.h"

@implementation BTAppState

+ (BTAppState *)sharedInstance
{
    static BTAppState *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BTAppState alloc] init];
    });
    return sharedInstance;
}

- (void)setDegreeUnitType:(BTDegreeUnitType)degreeUnitType
{
    BTDegreeUnitType oldValue = [self degreeUnitType];
    if (oldValue != degreeUnitType) {
        [[NSUserDefaults standardUserDefaults] setObject:@(degreeUnitType) forKey:kBTUserDefaultDegreeUnit];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDegreeUnitDidChangeNotification object:@(degreeUnitType)];
    }
}

- (BTDegreeUnitType)degreeUnitType
{
    NSNumber *degreeUnitObject = [[NSUserDefaults standardUserDefaults] objectForKey:kBTUserDefaultDegreeUnit];
    if (degreeUnitObject) {
        if ([degreeUnitObject integerValue] == 0) {
            return kBTDegreeFahrenheit;
        } else {
            return kBTDegreeCelsius;
        }
    } else {
        return kBTDegreeCelsius;
    }
}

@end
