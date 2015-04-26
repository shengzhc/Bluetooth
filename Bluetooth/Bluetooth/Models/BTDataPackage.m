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

- (NSData *)branchSendingBytesData
{
    UInt16 bytes = 0x0000;
    bytes |= ((self.branchNumber) << 8);
    bytes |= self.branchTargetTemperature;
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
