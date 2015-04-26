//
//  BTTemperatureAdjustViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTTemperatureAdjustViewController.h"
#import "BTCircleView.h"

@interface BTTemperatureAdjustViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet BTCircleView *circleBorderView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@end

@implementation BTTemperatureAdjustViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundView.layer.borderWidth = 4.0f;
    self.backgroundView.layer.cornerRadius = 6.0;
    
    [self updateTemperatureLabelWithTemperature:self.branch.branchTargetTemperature];
}

- (void)updateTemperatureLabelWithTemperature:(NSUInteger)temperature
{
    NSDictionary *numberAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:40.0f], NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *signAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:24.0f], NSForegroundColorAttributeName: [UIColor whiteColor], (NSString *)kCTSuperscriptAttributeName: @(1.25)};
    
    NSMutableAttributedString *temperatureText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", @(temperature).stringValue] attributes:numberAttributes];
    [temperatureText appendAttributedString:[[NSAttributedString alloc] initWithString:([BTAppState sharedInstance].isCelsius ? [NSString celsius] : [NSString fahrenheit]) attributes:signAttributes]];
    self.temperatureLabel.attributedText = temperatureText;
}

- (IBAction)didCloseButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.temperatureAdjustCompletionHandler) {
            self.temperatureAdjustCompletionHandler(YES, self.branch, nil);
        }
    }];
}

- (IBAction)didCheckButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.temperatureAdjustCompletionHandler) {
            self.temperatureAdjustCompletionHandler(NO, self.branch, nil);
        }
    }];
}

@end
