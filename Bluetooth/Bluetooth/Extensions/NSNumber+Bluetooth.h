//
//  NSNumber+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Bluetooth)

+ (NSNumber *)convertNumberToCelsius:(NSNumber *)number;
+ (NSNumber *)convertNumberToFahrenheit:(NSNumber *)number;

@end
