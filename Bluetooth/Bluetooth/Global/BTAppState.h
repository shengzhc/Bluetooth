//
//  BTAppState.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kBTDegreeFahrenheit,
    kBTDegreeCelsius
} BTDegreeUnitType;

@interface BTAppState : NSObject
@property (assign, nonatomic) BTDegreeUnitType degreeUnitType;

+ (BTAppState *)sharedInstance;
@end
