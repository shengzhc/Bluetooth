//
//  ViewController.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/16/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) CBCentralManager *centerManager;

@property (strong, nonatomic) CBPeripheral *connectingPeripheral;
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
@property (strong, nonatomic) NSArray *discoveriedCharacteristics;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.startButton.layer.cornerRadius = 5.0f;
    self.startButton.layer.borderWidth = 2.0f;
    self.startButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.stopButton.layer.cornerRadius = 5.0f;
    self.stopButton.layer.borderWidth = 2.0f;
    self.stopButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

- (IBAction)didStartButtonClicked:(id)sender
{
    CBUUID *uuid = [CBUUID UUIDWithString:@"1890"];
    [self.centerManager scanForPeripheralsWithServices:@[uuid] options:nil];
}

- (IBAction)didStopButtonClicked:(id)sender
{
    [self.centerManager stopScan];
}

- (void)connectWithPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options
{
    [self.centerManager connectPeripheral:peripheral options:options];
}

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    self.connectingPeripheral = peripheral;
    [self connectWithPeripheral:peripheral options:nil];
    self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, [NSString stringWithFormat:@"Scanned %@\n", peripheral]];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected to %@", peripheral);
    self.connectedPeripheral = peripheral;
    [self.connectedPeripheral discoverServices:nil];
    self.connectedPeripheral.delegate = self;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, @"Disconnected"];
    self.connectingPeripheral = nil;
    [self.centerManager cancelPeripheralConnection:self.connectedPeripheral];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.connectingPeripheral = peripheral;
        [self.centerManager connectPeripheral:self.connectingPeripheral options:nil];
    });
}

#pragma mark CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (self.connectedPeripheral == peripheral) {
        for (CBService *service in self.connectedPeripheral.services) {
            if ([service.UUID.UUIDString isEqualToString:@"1890"]) {
                [self.connectedPeripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    self.discoveriedCharacteristics = service.characteristics;
    
    for (CBCharacteristic *characteristic in self.discoveriedCharacteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:@"2A90"]) {
            self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, [NSString stringWithFormat:@"Sending read to %@", characteristic]];
            [self.connectedPeripheral readValueForCharacteristic:characteristic];
//            CBMutableCharacteristic *reading = [[CBMutableCharacteristic alloc] initWithType:characteristic.UUID properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
//            [self.connectedPeripheral readValueForCharacteristic:reading];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, [NSString stringWithFormat:@"Read Value %@", characteristic]];
    if (self.discoveriedCharacteristics && self.discoveriedCharacteristics.count > 0) {
        for (CBCharacteristic *characteristic in self.discoveriedCharacteristics) {
            if ([characteristic.UUID.UUIDString isEqualToString:@"2A91"]) {
                [peripheral writeValue:[NSData dataFromHexString:@"0xAB"] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, [NSString stringWithFormat:@"Write Value %@", characteristic]];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end

