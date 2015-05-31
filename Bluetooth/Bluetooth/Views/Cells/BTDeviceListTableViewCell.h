//
//  BTDeviceListTableViewCell.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/19/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTDeviceListTableViewCell;
@protocol BTDeviceListTableViewCellDelegate <NSObject>
@optional
- (void)deviceListTableViewCell:(BTDeviceListTableViewCell *)cell handleLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longGestureRecognizer;
@end

@interface BTDeviceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@property (weak, nonatomic) id< BTDeviceListTableViewCellDelegate > delegate;

+ (NSDictionary *)currentTemperatureTextAttributesWithIsActive:(BOOL)isActive;
+ (NSDictionary *)currentTemperatureDegreeAttributesWithIsActive:(BOOL)isActive;
+ (NSDictionary *)targetTemperatureTextAttributesWithIsActive:(BOOL)isActive;
+ (NSDictionary *)targetTemperatureDegreeAttributesWithIsActive:(BOOL)isActive;

@end
