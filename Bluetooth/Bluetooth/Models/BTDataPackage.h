//
//  BTDataPackage.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBranchBlock : NSObject
@property (assign, nonatomic) NSUInteger branchNumber;
@property (assign, nonatomic) NSUInteger branchTemperature;
@property (assign, nonatomic) NSUInteger branchTargetTemperature;

- (instancetype)initWithBranchNumber:(NSUInteger)branchNumber temperature:(NSUInteger)branchTemperature;
- (NSData *)branchBytesData;

@end

@interface BTDataPackage : NSObject
@property (strong, nonatomic) NSArray *branches;

- (instancetype)initWithBranchBlocks:(NSArray *)branches;
- (NSData *)dataPackageBytesData;

@end

