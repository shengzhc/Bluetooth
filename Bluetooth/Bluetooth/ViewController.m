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
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
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
    [self.centerManager scanForPeripheralsWithServices:nil options:nil];
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

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
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
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.connectedPeripheral = peripheral;
    self.connectedPeripheral.delegate = self;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark CBPeripheralDelegate
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

@end
