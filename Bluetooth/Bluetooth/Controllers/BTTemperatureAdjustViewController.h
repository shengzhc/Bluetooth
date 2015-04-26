//
//  BTTemperatureAdjustViewController.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTTemperatureAdjustViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) BTBranchBlock *branch;
@property (copy, nonatomic) void (^temperatureAdjustCompletionHandler)(BOOL isCancelled, BTBranchBlock *branch, id userInfo);
@end
