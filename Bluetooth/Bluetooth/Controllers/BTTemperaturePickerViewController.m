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

@interface BTTemperaturePickerViewController () < UIScrollViewDelegate >
@property (strong, nonatomic) IBOutlet BTTemperaturePickerSupporter *pickerSupporter;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *degreeUnitSwitchButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BTTemperaturePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSUInteger row = [self.pickerSupporter indexOfBranchTemperature:self.branch.branchTargetTemperature degreeUnitType: self.pickerSupporter.degreeUnitType];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)configureViews
{
    self.cancelButton.titleLabel.font = [UIFont bluetoothFontOfSize:28.0];
    self.cancelButton.layer.cornerRadius = 4.0;
    [self.cancelButton setBackgroundColor:[UIColor lightBambooColor]];
    self.cancelButton.clipsToBounds = YES;
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    self.doneButton.titleLabel.font = [UIFont bluetoothFontOfSize:28.0];
    self.doneButton.layer.cornerRadius = 4.0;
    [self.doneButton setBackgroundColor:[UIColor coralColor]];
    self.doneButton.clipsToBounds = YES;
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont bluetoothFontOfSize:28.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = self.branch.branchName;

    CGFloat fontSize = 32.0;
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
    self.degreeUnitSwitchButton.selected = self.pickerSupporter.degreeUnitType != kBTDegreeCelsius;
    
    [self.topContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTopContainer:)]];
}

- (NSIndexPath *)indexPathForCentralCellAtTableView:(UITableView *)tableView
{
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + tableView.bounds.size.height/2.0)];
    return indexPath;
}

- (void)didTapTopContainer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.temperaturePickerCompletionHandler) {
            self.temperaturePickerCompletionHandler(YES, self.branch, nil);
        }
    }];
}

- (IBAction)didDegreeUnitSwitchButtonClicked:(id)sender
{
    self.degreeUnitSwitchButton.selected = !self.degreeUnitSwitchButton.selected;
    self.pickerSupporter.degreeUnitType = self.degreeUnitSwitchButton.selected ? kBTDegreeFahrenheit : kBTDegreeCelsius;
    [self.tableView reloadData];
}

- (IBAction)didCancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.temperaturePickerCompletionHandler) {
            self.temperaturePickerCompletionHandler(YES, self.branch, nil);
        }
    }];
}

- (IBAction)didDoneButtonClicked:(id)sender
{
    NSIndexPath *indexPath = [self indexPathForCentralCellAtTableView:self.tableView];
    self.branch.branchTargetTemperature = [self.pickerSupporter branchTemperatureAtIndex:indexPath.row].doubleValue;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.temperaturePickerCompletionHandler) {
            self.temperaturePickerCompletionHandler(NO, self.branch, nil);
        }
    }];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.pickerSupporter tableView:tableView viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self.pickerSupporter tableView:tableView viewForFooterInSection:section];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint destContentOffset = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    CGFloat frontY = (int)(destContentOffset.y / self.tableView.rowHeight) * self.tableView.rowHeight;
    CGFloat nextY = (int)((destContentOffset.y + self.tableView.rowHeight) / self.tableView.rowHeight) * self.tableView.rowHeight;

    if (fabs(destContentOffset.y - frontY) > fabs(destContentOffset.y - nextY)) {
        targetContentOffset->y = nextY;
    } else {
        targetContentOffset->y = frontY;
    }
}

@end
