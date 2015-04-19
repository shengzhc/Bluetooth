//
//  UIFont+Bluetooth.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FONT_SIZE_TWEAK 0

typedef NS_ENUM(NSInteger, SourceSansProStyle) {
    SourceSansProStyleRegular,
    SourceSansProStyleItalic,
    SourceSansProStyleSemibold,
    SourceSansProStyleSemiboldItalic,
    SourceSansProStyleLight,
    SourceSansProStyleLightItalic,
    SourceSansProStyleExtraLight,
    SourceSansProStyleExtraLightItalic,
    SourceSansProStyleBold,
    SourceSansProStyleBoldItalic,
    SourceSansProStyleBlack,
    SourceSansProStyleBlackItalic
    
};

@interface UIFont (Bluetooth)

+ (UIFont *)bluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldBluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)semiboldBluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)lightBluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)condensedBluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)condensedSemiBoldBluetoothFontOfSize:(CGFloat)fontSize;
+ (UIFont *)bluetoothInterstitialFontOfSize:(CGFloat)fontSize;
+ (UIFont *)sourceSansProFontWithStyle:(SourceSansProStyle)style size:(CGFloat)size;

@end