//
//  BTAppState.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/25/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kBTDegreeFahrenheit,
    kBTDegreeCelsius
} BTDegreeUnitType;

@protocol BTAppStateChangeApprovalProtocol <NSObject>
@end

@interface BTAppState : NSObject
@property (assign, nonatomic, readonly) BTDegreeUnitType degreeUnitType;
+ (BTAppState *)sharedInstance;
- (void)updateDegreeUnitTypeWithType:(BTDegreeUnitType)type sender:(id)sender;
@end
