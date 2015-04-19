//
//  NSData+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "NSData+Bluetooth.h"

@implementation NSData(Bluetooth)

+ (NSData *)dataFromHexString:(NSString *)hexString;
{
    if ([hexString characterAtIndex:0] == '0' && [hexString characterAtIndex:1] == 'x') {
        hexString = [hexString substringFromIndex:2];
    }
    
    if (hexString.length %2 != 0) {
        hexString = [NSString stringWithFormat:@"0%@", hexString];
    }
    
    hexString = [hexString lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (NSUInteger i=0; i<hexString.length; i+=2) {
        char c = [hexString characterAtIndex:i];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [hexString characterAtIndex:i+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

@end