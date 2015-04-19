//
//  NSData+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (Bluetooth)

+ (NSData *)dataFromHexString:(NSString *)hexString;

@end