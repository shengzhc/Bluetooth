//
//  BTBluetoothManager.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/22/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTBluetoothManager.h"
#import "BTBLEServiceCharacteristicMapper.h"

@interface BTBluetoothManager ()
@property (strong, nonatomic) CBCentralManager *cbCentralManager;
@end

@implementation BTBluetoothManager
{
    dispatch_queue_t _central_queue;
    dispatch_queue_t _peripherals_connect_queue;
    
    NSLock *_discoveried_peripherals_lock;
    NSLock *_connecting_peripherals_lock;
    NSLock *_connected_peripherals_lock;
    
    NSTimer *_scanningTimer;
    NSTimer *_connectingTimer;

    NSMutableDictionary *_discoveried_peripherals;
    NSMutableDictionary *_connecting_peripherals;
    NSMutableDictionary *_connected_peripherals;
    
    BTBLEServiceCharacteristicMapper *_serviceCharacteristicMapper;
}

+ (BTBluetoothManager *)sharedInstance
{
    static BTBluetoothManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BTBluetoothManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _serviceCharacteristicMapper = [[BTBLEServiceCharacteristicMapper alloc] init];
        _central_queue = dispatch_queue_create("com.bluetooth.centralmanager", DISPATCH_QUEUE_CONCURRENT);
        _peripherals_connect_queue = dispatch_queue_create("com.bluetooth.peripheralsconnect", DISPATCH_QUEUE_SERIAL);
        
        self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_central_queue options:nil];
        
        _discoveried_peripherals = [[NSMutableDictionary alloc] init];
        _discoveried_peripherals_lock = [[NSLock alloc] init];
        
        _connecting_peripherals = [[NSMutableDictionary alloc] init];
        _connecting_peripherals_lock = [[NSLock alloc] init];
        
        _connected_peripherals = [[NSMutableDictionary alloc] init];
        _connected_peripherals_lock = [[NSLock alloc] init];
        
        _connectingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runPeripheralConnectionJob:) userInfo:nil repeats:YES];
        _scanningTimer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(runCentralManagerScanningJob:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)start
{
    [[NSRunLoop mainRunLoop] addTimer:_scanningTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_connectingTimer forMode:NSDefaultRunLoopMode];
    [_scanningTimer fire];
}

- (void)stop
{
    [_scanningTimer invalidate];
    [_connectingTimer invalidate];
    [self _stop];
}

- (void)_stop
{
    [self.cbCentralManager stopScan];
    
    [_scanningTimer invalidate];
    [_connectingTimer invalidate];
    
    for (CBPeripheral *peripheral in _discoveried_peripherals.allValues) {
        peripheral.delegate = nil;
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.cbCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    for (CBPeripheral *peripheral in _connecting_peripherals.allValues) {
        peripheral.delegate = nil;
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.cbCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    for (CBPeripheral *peripheral in _connected_peripherals.allValues) {
        peripheral.delegate = nil;
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.cbCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    
    [_discoveried_peripherals_lock lock];
    [_discoveried_peripherals removeAllObjects];
    [_discoveried_peripherals_lock unlock];
    
    [_connecting_peripherals_lock lock];
    [_connecting_peripherals removeAllObjects];
    [_connecting_peripherals_lock unlock];
    
    [_connected_peripherals_lock lock];
    [_connected_peripherals removeAllObjects];
    [_connected_peripherals_lock unlock];
    
    [[NSRunLoop mainRunLoop] addTimer:_scanningTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_connectingTimer forMode:NSDefaultRunLoopMode];
}

- (void)runCentralManagerScanningJob:(NSTimer *)timer
{
    [self _stop];
    [self.cbCentralManager scanForPeripheralsWithServices:[_serviceCharacteristicMapper supportedPeripheralServices] options:nil];
}

- (void)runPeripheralConnectionJob:(NSTimer *)timer
{
    dispatch_async(_peripherals_connect_queue, ^{
        if (_discoveried_peripherals.count > 0) {
            NSUInteger randomIndex = arc4random() % _discoveried_peripherals.count;
            [_discoveried_peripherals_lock lock];
            CBPeripheral *peripheral = [_discoveried_peripherals.allValues objectAtIndex:randomIndex];
            [_discoveried_peripherals_lock unlock];
            [_connecting_peripherals_lock lock];
            [_connecting_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
            [_connecting_peripherals_lock unlock];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.cbCentralManager connectPeripheral:peripheral options:nil];
            }];
        }
    });
}

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"centralManagerDidUpdateState: %ld", (long)central.state];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDiscoverPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_discoveried_peripherals_lock lock];
        [_discoveried_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
        [_discoveried_peripherals_lock unlock];
    }];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didConnectPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    
    [_connecting_peripherals_lock lock];
    [_connecting_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_connecting_peripherals_lock unlock];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_connected_peripherals_lock lock];
        [_connected_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
        [_connected_peripherals_lock unlock];
        
        peripheral.delegate = self;
        [peripheral discoverServices:[_serviceCharacteristicMapper supportedPeripheralServices]];
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didFailToConnectPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    
    [_connecting_peripherals_lock lock];
    [_connecting_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_connecting_peripherals_lock unlock];
    
    [_discoveried_peripherals_lock lock];
    [_discoveried_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
    [_discoveried_peripherals_lock unlock];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDisconnectPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    peripheral.delegate = nil;
    [_connected_peripherals_lock lock];
    [_connected_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_connected_peripherals_lock unlock];
}

#pragma mark CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDiscoverServices: %@, %@", peripheral.name, peripheral.services];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    for (CBService *service in peripheral.services) {
        if ([[_serviceCharacteristicMapper supportedPeripheralServices] containsObject:service.UUID]) {
            [peripheral discoverCharacteristics:[_serviceCharacteristicMapper supportedCharacteristicForServiceUUIDString:service.UUID.UUIDString] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDiscoverCharacteristicsForService: %@, %@", service.UUID.UUIDString, service.characteristics];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    
#warning SC modify to use reading queue
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([[_serviceCharacteristicMapper readCharacteristicUUIDsForServiceUUIDString:service.UUID.UUIDString] containsObject:characteristic.UUID]) {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didReadValueForCharacteristic: %@: %@, %@", characteristic.service.UUID.UUIDString, characteristic.UUID.UUIDString, characteristic.value];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
    
#warning SC modify to use reading complete queue
    BTDataPackage *readingPackage = [characteristic.value dataPackage];
    if (!readingPackage) {
        BTBranchBlock *block = [[BTBranchBlock alloc] initWithBranchNumber:1 temperature:10];
        readingPackage = [[BTDataPackage alloc] initWithBranchBlocks:@[block]];
    }

    BTBranchBlock *branch = readingPackage.branches[0];
    branch.branchTargetTemperature = 0xAB;
    
    for (CBCharacteristic *writeCharacteristic in characteristic.service.characteristics) {
        if ([[_serviceCharacteristicMapper writeCharacteristicUUIDsForServiceUUIDString:characteristic.service.UUID.UUIDString] containsObject:writeCharacteristic.UUID]) {
            [peripheral writeValue:[readingPackage dataPackageSendingBytesData] forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didWriteValueForCharacteristic: %@: %@, %@", characteristic.service.UUID.UUIDString, characteristic.UUID.UUIDString, characteristic.value];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationDebugLogNotification object:log];
    NSLog(@"%@", log);
#endif
}

@end
