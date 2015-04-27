//
//  BTTemperaturePickerViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/26/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperaturePickerViewController.h"
#import "BTTemperaturePickerSupporter.h"

@interface BTTemperaturePickerViewController ()
@property (strong, nonatomic) IBOutlet BTTemperaturePickerSupporter *pickerSupporter;
@end

@implementation BTTemperaturePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.pickerSupporter numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerSupporter pickerView:pickerView numberOfRowsInComponent:component];
}


#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self.pickerSupporter pickerView:pickerView widthForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self.pickerSupporter pickerView:pickerView rowHeightForComponent:component];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerSupporter pickerView:pickerView attributedTitleForRow:row forComponent:component];
}

@end
