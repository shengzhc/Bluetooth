//
//  BTTemperaturePickerViewController.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTemperaturePickerViewController : UIViewController

@property (strong, nonatomic) BTBranchBlock *branch;
@property (copy, nonatomic) void (^temperaturePickerCompletionHandler)(BOOL isCancelled, BTBranchBlock *branch, id userInfo);

@end
