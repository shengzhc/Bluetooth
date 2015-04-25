//
//  NSData+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDataPackage.h"

@interface NSData (Bluetooth)

+ (NSData *)dataFromHexString:(NSString *)hexString;
- (BTDataPackage *)dataPackage;

@end