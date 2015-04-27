//
//  BTLabelTableViewCell.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTLabelTableViewCell.h"

@interface BTLabelTableViewCell ()
@end

@implementation BTLabelTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mTextLabel.font = [UIFont bluetoothFontOfSize:40.0];
    self.mTextLabel.textColor = [UIColor whiteColor];
}

@end
