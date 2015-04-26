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
        self.branchTargetTemperature = arc4random()%20 + 10;
    }
    return self;
}

- (NSUInteger)branchTargetTemperature
{
    if (_branchTargetTemperature == NSUIntegerMax) {
        return NSUIntegerMax;
    }

    return _branchTargetTemperature;
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
