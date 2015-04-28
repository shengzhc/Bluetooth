//
//  BTDataPackage.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/24/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBranchBlock : NSObject < NSCopying >
@property (assign, nonatomic) NSUInteger branchNumber;
@property (assign, nonatomic) double branchTemperature;
@property (assign, nonatomic) double branchTargetTemperature;
@property (copy, nonatomic) NSString *branchName;

- (instancetype)initWithBranchNumber:(double)branchNumber temperature:(double)branchTemperature;
- (NSData *)branchSendingBytesData;

@end

@interface BTDataPackage : NSObject
@property (strong, nonatomic) NSArray *branches;

- (instancetype)initWithBranchBlocks:(NSArray *)branches;
- (NSData *)dataPackageSendingBytesData;

@end

