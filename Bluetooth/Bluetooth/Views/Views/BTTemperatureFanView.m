//
//  BTTemperatureFanView.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperatureFanView.h"

@interface BTTemperatureFanSegment ()
@property (assign, nonatomic) CGFloat startAngle;
@property (assign, nonatomic) CGFloat endAngle;
@end

@implementation BTTemperatureFanSegment

@end

@implementation BTTemperatureFanView

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
    NSMutableArray *segments = [NSMutableArray new];
    for (int i=0; i<4; i++) {
        BTTemperatureFanSegment *segment = [[BTTemperatureFanSegment alloc] init];
        segment.index = i;
        segment.startLocation = 0.25*i;
        segment.percentage = 0.25;
        [segments addObject:segment];
    }
    self.segments = segments;
}

- (void)setSegments:(NSArray *)segments
{
    self.segments = [segments sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return ((BTTemperatureFanSegment *)obj1).index > ((BTTemperatureFanSegment *)obj2).index;
    }];
    CGFloat startAngle = M_PI_4, fullAngle = M_PI * 2 * 3;
    for (BTTemperatureFanSegment *segment in self.segments) {
        segment.startAngle = startAngle + fullAngle * segment.startLocation;
        segment.endAngle = segment.startAngle + fullAngle * segment.percentage;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect myFrame = CGRectZero;
    CGFloat width = MAX(MIN(self.bounds.size.width, self.bounds.size.height) - self.lineWidth, 0);
    myFrame.size = CGSizeMake(width, width);
    myFrame.origin = CGPointMake((self.bounds.size.width - width)/2.0, (self.bounds.size.height - width)/2.0);
    CGPoint center = CGPointMake(CGRectGetMidX(myFrame), CGRectGetMidY(rect));

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    if (self.segments.count > 0) {
        BTTemperatureFanSegment *firstSegment = self.segments.firstObject;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:firstSegment.startAngle endAngle:firstSegment.endAngle clockwise:YES];
        CGContextSetStrokeColorWithColor(context, [firstSegment.color colorWithAlphaComponent:0.5f].CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    for (NSUInteger index = 1; index < self.segments.count-1; index++) {
        BTTemperatureFanSegment *segment = self.segments[index];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:segment.startAngle endAngle:segment.endAngle clockwise:YES];
        CGContextSetStrokeColorWithColor(context, [segment.color colorWithAlphaComponent:0.5f].CGColor);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (self.segments.count > 1) {
        BTTemperatureFanSegment *lastSegment = self.segments.firstObject;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:lastSegment.startAngle endAngle:lastSegment.endAngle clockwise:YES];
        CGContextSetStrokeColorWithColor(context, [lastSegment.color colorWithAlphaComponent:0.5f].CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
//    double startAngle = M_PI_4 * 3, endAngle = M_PI_4, fullAngle = M_PI * 2 - startAngle + endAngle;
//    double p1 = 0.3, p2 = 0.5, p3 = 0.2;
//    double angle1 = fullAngle * p1, angle2 = fullAngle * p2, angle3 = fullAngle * p3;

//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:startAngle endAngle:(startAngle+angle1) clockwise:YES];
//    CGContextSetLineWidth(context, self.lineWidth);
//    CGContextSetStrokeColorWithColor(context, [UIColor bambooColor].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextAddPath(context, path.CGPath);
//    CGContextDrawPath(context, kCGPathStroke);
    
//    path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:startAngle+angle1+angle2 endAngle:startAngle+angle1+angle2+angle3 clockwise:YES];
//    CGContextSetStrokeColorWithColor(context, [UIColor waveColor].CGColor);
//    CGContextAddPath(context, path.CGPath);
//    CGContextDrawPath(context, kCGPathStroke);
//
//    
//    path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:startAngle+angle1 endAngle:startAngle+angle1+angle2 clockwise:YES];
//    CGContextSetStrokeColorWithColor(context, [UIColor coralColor].CGColor);
//    CGContextSetLineCap(context, kCGLineCapButt);
//    CGContextAddPath(context, path.CGPath);
//    CGContextDrawPath(context, kCGPathStroke);
//

}

@end
