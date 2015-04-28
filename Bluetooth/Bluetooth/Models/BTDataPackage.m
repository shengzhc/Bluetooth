//
//  BTDataPackage.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDataPackage.h"

@implementation BTBranchBlock

- (instancetype)initWithBranchNumber:(double)branchNumber temperature:(double)branchTemperature
{
    if (self = [super init]) {
        self.branchNumber = branchNumber;
        self.branchTemperature = branchTemperature;
        self.branchTargetTemperature = NSUIntegerMax;
        self.branchTargetTemperature = arc4random()%20 + 10;
        self.branchName = [[self reservedTitles] objectAtIndex:self.branchNumber % [self reservedTitles].count];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    BTBranchBlock *copiedBranch = [[BTBranchBlock alloc] initWithBranchNumber:self.branchNumber temperature:self.branchTemperature];
    copiedBranch.branchTargetTemperature = self.branchTargetTemperature;
    return copiedBranch;
}

- (NSArray *)reservedTitles
{
    return @[@"Kitchen", @"Living Room", @"Baby Bedroom", @"Study Room"];
}

- (double)branchTargetTemperature
{
    if (_branchTargetTemperature == NSUIntegerMax) {
        return NSUIntegerMax;
    }

    return _branchTargetTemperature;
}

- (NSData *)branchSendingBytesData
{
    UInt16 bytes = 0x0000;
    bytes |= ((self.branchNumber) << 8);
    bytes |= (NSUInteger)self.branchTargetTemperature;
    NSLog(@"Hex value of char is 0x%02x", (unsigned int) bytes);
    return [NSData dataWithBytes:&bytes length:sizeof(UInt16)];
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

- (NSData *)dataPackageSendingBytesData
{
    NSMutableData *bytes = [[NSMutableData alloc] init];
    for (NSUInteger index=0; index < self.branches.count; index++) {
        BTBranchBlock *branch = self.branches[index];
        [bytes appendData:[branch branchSendingBytesData]];
    }
    return bytes;
}

@end
