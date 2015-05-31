//
//  BTDataPackage.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDataPackage.h"

@implementation BTBranchBlock

- (instancetype)initWithBranchNumber:(double)branchNumber temperature:(double)branchTemperature targetTemperature:(double)branchTargetTemperature
{
    if (self = [super init]) {
        self.branchNumber = branchNumber;
        self.branchTemperature = branchTemperature;
        self.branchTargetTemperature = branchTargetTemperature;
        self.branchName = [[self reservedTitles] objectAtIndex:self.branchNumber % [self reservedTitles].count];
        self.isActive = (NSLocationInRange((NSUInteger)self.branchTemperature, NSMakeRange(kBTTemperatureMinVoidValue+1, kBTTemperatureMaxVoidValue-1)));
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    BTBranchBlock *copiedBranch = [[BTBranchBlock alloc] initWithBranchNumber:self.branchNumber temperature:self.branchTemperature targetTemperature:self.branchTargetTemperature];
    copiedBranch.isActive = self.isActive;
    return copiedBranch;
}

- (NSArray *)reservedTitles
{
    return @[@"Kitchen", @"Living Room", @"Baby Bedroom", @"Study Room"];
}

- (NSData *)branchSendingBytesData
{
    UInt16 bytes = 0x0000;
    UInt8 firstByte = self.branchNumber;
    UInt8 secondByte = ([BTAppState sharedInstance].isColdType ? 0x80 : 0x00) | (UInt8)self.branchTargetTemperature;
    bytes = (firstByte << 8) | secondByte;

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

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[BTDataPackage class]]) {
        BTDataPackage *dataPackage = (BTDataPackage *)object;
        if ([dataPackage.serviceUUIDString isEqualToString:self.serviceUUIDString] && [dataPackage.readingCharacteristicsUUIDString isEqualToString:self.readingCharacteristicsUUIDString]) {
            return YES;
        }
    }
    return NO;
}

@end
