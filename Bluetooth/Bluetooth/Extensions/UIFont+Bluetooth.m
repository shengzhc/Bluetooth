//
//  UIFont+Bluetooth.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "UIFont+Bluetooth.h"

NSString* Bluetooth_Font = @"SourceSansPro-Regular";
NSString* Bluetooth_Font_Italic = @"SourceSansPro-Italic";
NSString* Bluetooth_Font_Bold = @"SourceSansPro-Bold";
NSString* Bluetooth_Font_Semibold = @"SourceSansPro-Semibold";
NSString* Bluetooth_Font_Cond = @"SourceSansPro-Regular";
NSString* Bluetooth_Font_Cond_Semibold = @"SourceSansPro-Regular";
NSString* Bluetooth_Font_Interstitial = @"Sketchnote Text";

@implementation UIFont (Bluetooth)

+ (UIFont *)bluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font size:fontSize];
}

+ (UIFont *)italicBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Italic size:fontSize];
}

+ (UIFont *)boldBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Bold size:fontSize];
}

+ (UIFont *)semiboldBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Semibold size:fontSize];
}

+ (UIFont *)lightBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont sourceSansProFontWithStyle:SourceSansProStyleLight size:fontSize];
}

+ (UIFont *)condensedBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Cond size:fontSize];
}

+ (UIFont *)condensedSemiBoldBluetoothFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Cond_Semibold size:fontSize];
}

+ (UIFont *)bluetoothInterstitialFontOfSize:(CGFloat)fontSize
{
    fontSize += FONT_SIZE_TWEAK;
    return [UIFont fontWithName:Bluetooth_Font_Interstitial size:fontSize];
}

+ (UIFont *)sourceSansProFontWithStyle:(SourceSansProStyle)style size:(CGFloat)size
{
    UIFont *font = nil;
    switch (style) {
        case SourceSansProStyleRegular:
            font = [UIFont fontWithName:@"SourceSansPro-Regular" size:size];
            break;
            
        case SourceSansProStyleItalic:
            font = [UIFont fontWithName:@"SourceSansPro-It" size:size];
            break;
            
        case SourceSansProStyleSemibold:
            font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:size];
            break;
            
        case SourceSansProStyleSemiboldItalic:
            font = [UIFont fontWithName:@"SourceSansPro-SemiboldIt" size:size];
            break;
            
        case SourceSansProStyleLight:
            font = [UIFont fontWithName:@"SourceSansPro-Light" size:size];
            break;
            
        case SourceSansProStyleLightItalic:
            font = [UIFont fontWithName:@"SourceSansPro-LightIt" size:size];
            break;
            
        case SourceSansProStyleExtraLight:
            font = [UIFont fontWithName:@"SourceSansPro-ExtraLight" size:size];
            break;
            
        case SourceSansProStyleExtraLightItalic:
            font = [UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:size];
            break;
            
        case SourceSansProStyleBold:
            font = [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
            break;
            
        case SourceSansProStyleBoldItalic:
            font = [UIFont fontWithName:@"SourceSansPro-BoldIt" size:size];
            break;
            
        case SourceSansProStyleBlack:
            font = [UIFont fontWithName:@"SourceSansPro-Black" size:size];
            break;
            
        case SourceSansProStyleBlackItalic:
            font = [UIFont fontWithName:@"SourceSansPro-BlackIt" size:size];
            break;
    }
    return font;
}

@end
