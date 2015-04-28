//
//  BTDeviceListViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListViewController.h"
#import "BTTemperatureAdjustViewController.h"
#import "BTTemperaturePickerViewController.h"

#import "BTDeviceListSupporter.h"

#import "BTDeviceListTableViewCell.h"
#import "BTDegreeUnitSwitchCell.h"

#import "BTFadeAnimator.h"
#import "BTPickerAnimator.h"

@interface BTDeviceListViewController () < BTDeviceListSupporterDelegate, BTDeviceListTableViewCellDelegate, UIViewControllerTransitioningDelegate >
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet BTDeviceListSupporter *deviceListSupporter;
@end

@implementation BTDeviceListViewController
{
    BOOL _isHandlingLongPress;
}

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textView setFont:[UIFont lightBluetoothFontOfSize:12.0f]];
    [self.textView setTextColor:[UIColor whiteColor]];
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.deviceListSupporter.delegate = self;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLogNotification:) name:@"DebugLogNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDegreeUnitChangedNotification:) name:kBTNotificationDegreeUnitDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTBluetoothManager sharedInstance] start];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveDegreeUnitChangedNotification:(NSNotification *)notification
{
    if (self.tableView) {
        NSArray *visiableCells = [self.tableView visibleCells];
        NSMutableArray *reloadIndexPaths = [NSMutableArray new];
        for (UITableViewCell *cell in visiableCells) {
            if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
                [reloadIndexPaths addObject:[self.tableView indexPathForCell:cell]];
            }
        }
        [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)presentBranchTemperatureAdjustViewControllerWithBranch:(BTBranchBlock *)branch withIndexPath:(NSIndexPath *)indexPath
{
    BTTemperatureAdjustViewController *adjustViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kBTTemperatureAdjustViewControllerIdentifier];
    adjustViewController.branch = branch;
    adjustViewController.modalPresentationStyle = UIModalPresentationCustom;
    adjustViewController.transitioningDelegate = self;
    
    __weak BTDeviceListViewController *weakSelf = self;
    adjustViewController.temperatureAdjustCompletionHandler = ^(BOOL isCancelled, BTBranchBlock *branch, id userInfo) {
        _isHandlingLongPress = NO;
        if (!isCancelled) {
            __strong BTDeviceListViewController *deviceListViewController = weakSelf;
            if (deviceListViewController) {
                BTBranchBlock *originalBranch = [deviceListViewController.deviceListSupporter branchWithBranchNumber:branch.branchNumber];
                if (originalBranch.branchTargetTemperature != branch.branchTargetTemperature) {
                    [deviceListViewController.deviceListSupporter updateBranchWithBranchNumber:branch.branchNumber updatedBranch:branch];
                    [deviceListViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    };
    [self presentViewController:adjustViewController animated:YES completion:nil];
}

- (void)presentBranchTemperaturePickerViewControllerWithBranch:(BTBranchBlock *)branch withIndexPath:(NSIndexPath *)indexPath
{
    BTTemperaturePickerViewController *pickerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kBTTemperaturePickerViewControllerIdentifier];
    pickerViewController.branch = branch;
    pickerViewController.modalPresentationStyle = UIModalPresentationCustom;
    pickerViewController.transitioningDelegate = self;

    __weak BTDeviceListViewController *weakSelf = self;
    pickerViewController.temperaturePickerCompletionHandler = ^(BOOL isCancelled, BTBranchBlock *branch, id userInfo) {
        _isHandlingLongPress = NO;
        if (!isCancelled) {
            __strong BTDeviceListViewController *deviceListViewController = weakSelf;
            if (deviceListViewController) {
                branch.branchTargetTemperature = rand()%20 + 16;
                BTBranchBlock *originalBranch = [deviceListViewController.deviceListSupporter branchWithBranchNumber:branch.branchNumber];
                if (originalBranch.branchTargetTemperature != branch.branchTargetTemperature) {
                    [deviceListViewController.deviceListSupporter updateBranchWithBranchNumber:branch.branchNumber updatedBranch:branch];
                    [deviceListViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    };
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.deviceListSupporter numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceListSupporter tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.deviceListSupporter tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BTDeviceListTableViewCell class]]) {
        ((BTDeviceListTableViewCell *)cell).delegate = self;
    } else if ([cell isKindOfClass:[BTDegreeUnitSwitchCell class]]) {
        ((BTDegreeUnitSwitchCell *)cell).switchButton.selected = ![BTAppState sharedInstance].isCelsius;
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 76.0f;
    } else {
        return 44.0f;
    }
}

- (void)didReceiveLogNotification:(NSNotification *)notification
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.textView.text = [NSString stringWithFormat:@"%@\n%@", self.textView.text, notification.object];
    }];
}

#pragma mark BTDeviceListTableViewCellDelegate
- (void)deviceListTableViewCell:(BTDeviceListTableViewCell *)cell handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longGestureRecognizer
{
    if (_isHandlingLongPress) {
        return;
    }

    _isHandlingLongPress = YES;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    BTBranchBlock *copiedBranch = [[self.deviceListSupporter branchWithIndex:indexPath.row] copy];
    [self presentBranchTemperaturePickerViewControllerWithBranch:copiedBranch withIndexPath:indexPath];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if ([presented isKindOfClass:[BTTemperatureAdjustViewController class]]) {
        BTFadeAnimator *animator = [[BTFadeAnimator alloc] init];
        animator.presenting = YES;
        return animator;
    } else if ([presented isKindOfClass:[BTTemperaturePickerViewController class]]) {
        BTPickerAnimator *animator = [[BTPickerAnimator alloc] init];
        animator.presenting = YES;
        return animator;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if ([dismissed isKindOfClass:[BTTemperatureAdjustViewController class]]) {
        BTFadeAnimator *animator = [[BTFadeAnimator alloc] init];
        animator.presenting = NO;
        return animator;
    } else if ([dismissed isKindOfClass:[BTTemperaturePickerViewController class]]) {
        BTPickerAnimator *animator = [[BTPickerAnimator alloc] init];
        animator.presenting = NO;
        return animator;
    }
    return nil;
}

@end
