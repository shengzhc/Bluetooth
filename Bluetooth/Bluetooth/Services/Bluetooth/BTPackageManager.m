//
//  BTPackageManager.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/28/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTPackageManager.h"

@interface BTPackageManager ()

@end

@implementation BTPackageManager
{
    NSLock *_received_packages_lock;
    NSLock *_writting_packages_lock;
    
    NSMutableArray *_received_packages;
    NSMutableArray *_writting_packages;
    
    NSTimer *_sendingTimer;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _received_packages_lock = [[NSLock alloc] init];
        _writting_packages_lock = [[NSLock alloc] init];
        
        _received_packages = [[NSMutableArray alloc] init];
        _writting_packages = [[NSMutableArray alloc] init];
        
        _sendingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runWriteDataPackageJob:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)pushReceivedPackage:(BTDataPackage *)dataPackage withSender:(id)sender
{
    [_received_packages_lock lock];
    [_received_packages addObject:dataPackage];
    [_received_packages_lock unlock];
}

- (void)pushWrittingPackage:(BTDataPackage *)dataPackage withSender:(id)sender
{
    [_writting_packages_lock lock];
    [_writting_packages addObject:dataPackage];
    [_writting_packages_lock unlock];
    
    if (_writting_packages.count > 0 && !_sendingTimer.isValid) {
        [self _startTimer];
    } else {
        [self _stopTimer];
    }
}

- (void)runWriteDataPackageJob:(NSTimer *)timer
{
    BTDataPackage *dataPackage = nil;
    [_writting_packages_lock lock];
    if (_writting_packages.count > 0) {
        dataPackage = _writting_packages.firstObject;
        [_writting_packages removeObjectAtIndex:0];
    }
    [_writting_packages_lock unlock];
    
    if (dataPackage) {
        NSLog(@"%@", dataPackage);
    }
}

- (void)_startTimer
{
    if (!_sendingTimer.isValid) {
        [[NSRunLoop mainRunLoop] addTimer:_sendingTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)_stopTimer
{
    if (_sendingTimer.isValid) {
        [_sendingTimer invalidate];
    }
}

@end
