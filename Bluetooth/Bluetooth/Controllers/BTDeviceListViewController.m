//
//  BTDeviceListViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListViewController.h"

@interface BTDeviceListViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation BTDeviceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont bluetoothFontOfSize:14.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLogNotification:) name:@"DebugLogNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[BTBluetoothManager sharedInstance] start];
}

- (void)didReceiveLogNotification:(NSNotification *)notification
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, notification.object];
    }];
}

@end
