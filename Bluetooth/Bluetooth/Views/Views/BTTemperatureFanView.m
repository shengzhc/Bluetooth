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
    BTTemperatureFanSegment *segment1 = [[BTTemperatureFanSegment alloc] init];
    segment1.index = 1;
    segment1.startLocation = 0;
    segment1.percentage = 0.2;
    segment1.color = [UIColor lightWaveColor];
    [segments addObject:segment1];

    BTTemperatureFanSegment *segment2 = [[BTTemperatureFanSegment alloc] init];
    segment2.index = 2;
    segment2.startLocation = 0.2;
    segment2.percentage = 0.6;
    segment2.color = [UIColor lightBambooColor];
    [segments addObject:segment2];

    BTTemperatureFanSegment *segment3 = [[BTTemperatureFanSegment alloc] init];
    segment3.index = 3;
    segment3.startLocation = 0.8;
    segment3.percentage = 0.2;
    segment3.color = [UIColor lightCoralColor];
    [segments addObject:segment3];

    self.segments = segments;
}

- (void)setSegments:(NSArray *)segments
{
    _segments = [segments sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return ((BTTemperatureFanSegment *)obj1).index > ((BTTemperatureFanSegment *)obj2).index;
    }];
    CGFloat startAngle = M_PI_4 * 3, fullAngle = M_PI_2 * 3;
    for (BTTemperatureFanSegment *segment in self.segments) {
        segment.startAngle = startAngle + fullAngle * segment.startLocation;
        segment.endAngle = segment.startAngle + fullAngle * segment.percentage;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect myFrame = CGRectZero;
    CGFloat alpha = 0.3f;
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
        CGContextSetStrokeColorWithColor(context, [firstSegment.color colorWithAlphaComponent:alpha].CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
        
        if (self.percentage >= firstSegment.startLocation) {
            CGFloat endAngle = firstSegment.startAngle + MIN(1.0, (self.percentage-firstSegment.startLocation)/firstSegment.percentage) * (firstSegment.endAngle - firstSegment.startAngle);
            
            path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:firstSegment.startAngle endAngle:endAngle clockwise:YES];
            
            CGContextSetStrokeColorWithColor(context, firstSegment.color.CGColor);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextAddPath(context, path.CGPath);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    if (self.segments.count > 1) {
        BTTemperatureFanSegment *lastSegment = self.segments.lastObject;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:lastSegment.startAngle endAngle:lastSegment.endAngle clockwise:YES];
        CGContextSetStrokeColorWithColor(context, [lastSegment.color colorWithAlphaComponent:alpha].CGColor);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
        
        if (self.percentage >= lastSegment.startLocation) {
            CGFloat endAngle = lastSegment.startAngle + MIN(1.0, (self.percentage-lastSegment.startLocation)/lastSegment.percentage) * (lastSegment.endAngle - lastSegment.startAngle);
            
            path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:lastSegment.startAngle endAngle:endAngle clockwise:YES];
            
            CGContextSetStrokeColorWithColor(context, lastSegment.color.CGColor);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextAddPath(context, path.CGPath);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    for (NSUInteger index = 1; index < self.segments.count-1; index++) {
        BTTemperatureFanSegment *segment = self.segments[index];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:segment.startAngle endAngle:segment.endAngle clockwise:YES];
        CGContextSetStrokeColorWithColor(context, [segment.color colorWithAlphaComponent:alpha].CGColor);
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathStroke);
        
        if (self.percentage >= segment.startLocation) {
            CGFloat endAngle = segment.startAngle + MIN(1.0, (self.percentage-segment.startLocation)/segment.percentage) * (segment.endAngle - segment.startAngle);
            
            path = [UIBezierPath bezierPathWithArcCenter:center radius:width/2.0 startAngle:segment.startAngle endAngle:endAngle clockwise:YES];
            
            CGContextSetStrokeColorWithColor(context, segment.color.CGColor);
            CGContextSetLineCap(context, self.percentage > (segment.startLocation + segment.percentage) ? kCGLineCapButt : kCGLineCapRound);
            CGContextAddPath(context, path.CGPath);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
}

@end
