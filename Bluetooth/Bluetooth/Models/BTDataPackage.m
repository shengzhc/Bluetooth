//
//  BTDataPackage.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDataPackage.h"

@implementation BTBranchBlock

- (instancetype)initWithBranchNumber:(NSUInteger)branchNumber temperature:(NSUInteger)branchTemperature
{
    if (self = [super init]) {
        self.branchNumber = branchNumber;
        self.branchTemperature = branchTemperature;
        self.branchTargetTemperature = NSUIntegerMax;
        self.branchTargetTemperature = rand()%40+10;
    }
    return self;
}

- (NSUInteger)branchTemperature
{
    BOOL isCelsius = [BTAppState sharedInstance].degreeUnitType == kBTDegreeCelsius;
    return isCelsius ? _branchTemperature : [NSNumber convertNumberToFahrenheit:@(_branchTemperature)].integerValue;
}

- (NSUInteger)branchTargetTemperature
{
    if (_branchTargetTemperature == NSUIntegerMax) {
        return NSUIntegerMax;
    }
    
    BOOL isCelsius = [BTAppState sharedInstance].degreeUnitType == kBTDegreeCelsius;
    return isCelsius ? _branchTemperature : [NSNumber convertNumberToFahrenheit:@(_branchTargetTemperature)].integerValue;
}

@end

@implementation BTDataPackage

- (instancetype)initWithBranchBlocks:(NSArray *)branches
{
    if (self = [super init]) {
        self.branches = [NSArray arrayWithArray:branches];
    }
    return self;
}

@end
