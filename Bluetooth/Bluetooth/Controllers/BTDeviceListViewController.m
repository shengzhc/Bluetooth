//
//  BTDeviceListViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDeviceListViewController.h"
#import "BTTemperatureAdjustViewController.h"
#import "BTDeviceListSupporter.h"

#import "BTDeviceListTableViewCell.h"
#import "BTDegreeUnitSwitchCell.h"

#import "BTFadeAnimator.h"

@interface BTDeviceListViewController () < BTDeviceListSupporterDelegate, BTDeviceListTableViewCellDelegate, UIViewControllerTransitioningDelegate >
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet BTDeviceListSupporter *tableSupporter;
@end

@implementation BTDeviceListViewController
{
    BOOL _isHandlingLongPress;
}

#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.font = [UIFont bluetoothFontOfSize:14.0];
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    self.tableSupporter.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDegreeUnitChangedNotification:) name:kBTNotificationDegreeUnitDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLogNotification:) name:@"DebugLogNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[BTBluetoothManager sharedInstance] start];
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

- (void)presentBranchTemperatureAdjustViewControllerWithBranch:(BTBranchBlock *)branch
{
    BTTemperatureAdjustViewController *adjustViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kBTTemperatureAdjustViewControllerIdentifier];
    adjustViewController.branch = branch;
    adjustViewController.modalPresentationStyle = UIModalPresentationCustom;
    adjustViewController.transitioningDelegate = self;
    adjustViewController.temperatureAdjustCompletionHandler = ^(BOOL isCancelled, BTBranchBlock *branch, id userInfo) {
        _isHandlingLongPress = NO;
        NSLog(@"%@", branch);
    };
    [self presentViewController:adjustViewController animated:YES completion:nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSupporter numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableSupporter tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableSupporter tableView:tableView cellForRowAtIndexPath:indexPath];
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
    BTBranchBlock *branch = [[BTBranchBlock alloc] initWithBranchNumber:1 temperature:arc4random()%20+10];
    [self presentBranchTemperatureAdjustViewControllerWithBranch:branch];
}

#pragma mark UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    BTFadeAnimator *animator = [[BTFadeAnimator alloc] init];
    animator.presenting = YES;
    return animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    BTFadeAnimator *animator = [[BTFadeAnimator alloc] init];
    return animator;
}

@end
