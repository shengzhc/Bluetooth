//
//  BTPackageManager.h
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/28/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTPackageManagerUpdateProtocol <NSObject>
@end

@interface BTPackageManager : NSObject

- (void)pushReceivedPackage:(BTDataPackage *)dataPackage withSender:(id)sender;
- (void)pushWrittingPackage:(BTDataPackage *)dataPackage withSender:(id)sender;

@end
