//
//  BTTemperaturePickerSupporter.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/27/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTemperaturePickerSupporter : NSObject < UITableViewDataSource >
@property (assign, nonatomic) BTDegreeUnitType degreeUnitType;
@property (assign, nonatomic) double temperature;
@end
