//
//  BTCircleView.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTCircleView.h"

@implementation BTCircleView

- (instancetype)init
{
    if (self = [super init]) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.lineWidth = 4.0f;
    self.borderColor = [UIColor bambooColor];
    self.fillColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = CGRectZero;
    CGFloat width = MAX(MIN(self.bounds.size.width, self.bounds.size.height) - self.lineWidth, 0);
    myFrame.size = CGSizeMake(width, width);
    myFrame.origin = CGPointMake((self.bounds.size.width - width)/2.0, (self.bounds.size.height - width)/2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:myFrame cornerRadius:myFrame.size.width/2.0];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}

@end
