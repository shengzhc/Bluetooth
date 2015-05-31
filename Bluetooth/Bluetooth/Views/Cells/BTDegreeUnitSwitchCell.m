//
//  BTDegreeUnitSwitchCell.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDegreeUnitSwitchCell.h"

@interface BTDegreeUnitSwitchCell () < BTAppStateChangeApprovalProtocol >
@end

@implementation BTDegreeUnitSwitchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat fontSize = 24.0f;
    
    NSDictionary *highlightAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *grayAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize], NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:.5f]};
    NSDictionary *seperatorAttributes = @{NSFontAttributeName: [UIFont bluetoothFontOfSize:fontSize - 2], NSForegroundColorAttributeName: [UIColor coralColor], NSBaselineOffsetAttributeName: @(1.5)};
    
    NSMutableAttributedString *celsiusState = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString celsius]] attributes:highlightAttributes];
    [celsiusState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [celsiusState appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString fahrenheit] attributes:grayAttributes]];

    NSMutableAttributedString *fahrenheitState = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString celsius]] attributes:grayAttributes];
    [fahrenheitState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [fahrenheitState appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString fahrenheit] attributes:highlightAttributes]];

    [self.switchButton setAttributedTitle:celsiusState forState:UIControlStateNormal];
    [self.switchButton setAttributedTitle:fahrenheitState forState:UIControlStateSelected];
    
    NSMutableAttributedString *coldState = [[NSMutableAttributedString alloc] initWithString:@"Cold" attributes:highlightAttributes];
    [coldState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [coldState appendAttributedString:[[NSAttributedString alloc] initWithString:@"Warm" attributes:grayAttributes]];
    
    NSMutableAttributedString *warmState = [[NSMutableAttributedString alloc] initWithString:@"Cold" attributes:grayAttributes];
    [warmState appendAttributedString:[[NSAttributedString alloc] initWithString:@" / " attributes:seperatorAttributes]];
    [warmState appendAttributedString:[[NSAttributedString alloc] initWithString:@"Warm" attributes:highlightAttributes]];
    
    [self.modeSwitchButton setAttributedTitle:coldState forState:UIControlStateNormal];
    [self.modeSwitchButton setAttributedTitle:warmState forState:UIControlStateSelected];
}

- (IBAction)didSwitchButtonClicked:(id)sender
{
    self.switchButton.selected = !self.switchButton.selected;
    [[BTAppState sharedInstance] updateDegreeUnitTypeWithType:self.switchButton.selected ? kBTDegreeFahrenheit : kBTDegreeCelsius sender:self];
}

- (IBAction)didModeSwitchButtonClicked:(id)sender
{
    self.modeSwitchButton.selected = !self.modeSwitchButton.selected;
    [[BTAppState sharedInstance] updateColdTypeWithIsColdType:!self.modeSwitchButton.selected sender:self];
}

@end
