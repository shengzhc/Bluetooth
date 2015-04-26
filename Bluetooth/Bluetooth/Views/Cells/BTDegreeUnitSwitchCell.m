//
//  BTDegreeUnitSwitchCell.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTDegreeUnitSwitchCell.h"

@interface BTDegreeUnitSwitchCell ()
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
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
    
    [self.switchButton setBackgroundImage:nil forState:(UIControlStateNormal | UIControlStateSelected)];
}

- (IBAction)didSwitchButtonClicked:(id)sender
{
    self.switchButton.selected = !self.switchButton.selected;
}

@end
