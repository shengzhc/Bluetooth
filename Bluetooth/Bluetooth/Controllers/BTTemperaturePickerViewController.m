//
//  BTTemperaturePickerViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperaturePickerViewController.h"

#import "BTTemperaturePickerSupporter.h"

#import "BTLabelTableViewCell.h"

@interface BTTemperaturePickerViewController ()
@property (strong, nonatomic) IBOutlet BTTemperaturePickerSupporter *pickerSupporter;
@property (weak, nonatomic) IBOutlet UIView *bottomContainer;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *temperatureTableView;
@property (weak, nonatomic) IBOutlet UIButton *degreeUnitSwitchButton;
@end

@implementation BTTemperaturePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cancelButton.titleLabel.font = [UIFont bluetoothFontOfSize:20.0f];
    self.cancelButton.layer.cornerRadius = 4.0;
    [self.cancelButton setBackgroundColor:[[UIColor lightBambooColor] colorWithAlphaComponent:0.8f]];
    self.cancelButton.clipsToBounds = YES;
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    self.doneButton.titleLabel.font = [UIFont bluetoothFontOfSize:20.0f];
    self.doneButton.layer.cornerRadius = 4.0;
    [self.doneButton setBackgroundColor:[[UIColor lightCoralColor] colorWithAlphaComponent:0.8]];
    self.doneButton.clipsToBounds = YES;
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    CGFloat fontSize = 20.0f;
    
    NSDictionary *highlightAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *grayAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize], NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:.5f]};
    NSDictionary *seperatorAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize - 2], NSForegroundColorAttributeName: [UIColor coralColor], NSBaselineOffsetAttributeName: @(1.5)};
    
    NSMutableAttributedString *celsiusState = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString celsius]] attributes:highlightAttributes];
    [celsiusState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [celsiusState appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString fahrenheit] attributes:grayAttributes]];
    
    NSMutableAttributedString *fahrenheitState = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString celsius]] attributes:grayAttributes];
    [fahrenheitState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [fahrenheitState appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString fahrenheit] attributes:highlightAttributes]];
    
    [self.degreeUnitSwitchButton setAttributedTitle:celsiusState forState:UIControlStateNormal];
    [self.degreeUnitSwitchButton setAttributedTitle:fahrenheitState forState:UIControlStateSelected];
}

- (IBAction)didCancelButtonClicked:(id)sender
{
}

- (IBAction)didDoneButtonClicked:(id)sender
{
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.pickerSupporter numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pickerSupporter tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.pickerSupporter tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

@end
