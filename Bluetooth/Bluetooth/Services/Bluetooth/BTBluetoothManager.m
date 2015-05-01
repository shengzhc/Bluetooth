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
    dispatch_queue_t _characteristic_reading_queue;
    dispatch_queue_t _characteristic_writting_queue;
    
    NSLock *_discoveried_peripherals_lock;
    NSLock *_connecting_peripherals_lock;
    NSLock *_connected_peripherals_lock;
    NSLock *_writting_packages_lock;
    
    NSTimer *_scanningTimer;
    NSTimer *_connectingTimer;
    NSTimer *_writtingTimer;

    NSMutableDictionary *_discoveried_peripherals;
    NSMutableDictionary *_connecting_peripherals;
    NSMutableDictionary *_connected_peripherals;
    
    NSMutableArray *_writting_packages;
    
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
        _characteristic_reading_queue = dispatch_queue_create("com.bluetooth.characteristic_reading_queue", DISPATCH_QUEUE_SERIAL);
        _characteristic_writting_queue = dispatch_queue_create("com.bluetooth.characteristic_writting_queue", DISPATCH_QUEUE_SERIAL);
        
        self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_central_queue options:nil];
        
        _discoveried_peripherals = [[NSMutableDictionary alloc] init];
        _discoveried_peripherals_lock = [[NSLock alloc] init];
        
        _connecting_peripherals = [[NSMutableDictionary alloc] init];
        _connecting_peripherals_lock = [[NSLock alloc] init];
        
        _connected_peripherals = [[NSMutableDictionary alloc] init];
        _connected_peripherals_lock = [[NSLock alloc] init];
        
        _writting_packages = [[NSMutableArray alloc] init];
        _writting_packages_lock = [[NSLock alloc] init];
    }
    
    return self;
}

#pragma mark APIs
- (void)start
{
    _connectingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runPeripheralConnectionJob:) userInfo:nil repeats:YES];
    _scanningTimer = [NSTimer timerWithTimeInterval:30.0f target:self selector:@selector(runCentralManagerScanningJob:) userInfo:nil repeats:YES];
    _writtingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runWrittingJob:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_scanningTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_connectingTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_writtingTimer forMode:NSDefaultRunLoopMode];
    [_scanningTimer fire];
}

- (void)stop
{
    [_scanningTimer invalidate];
    [_connectingTimer invalidate];
    [_writtingTimer invalidate];
    
    _scanningTimer = nil;
    _connectingTimer = nil;
    _writtingTimer = nil;

    [self _stop];
}

- (void)sendDataPackage:(BTDataPackage *)dataPackage withSender:(id)sender
{
    if (![sender conformsToProtocol:@protocol(BTBluetoothManagerPermissionDelegate)]) {
        return;
    }
    
    [_writting_packages_lock lock];
    NSUInteger index = 0;
    for (; index < _writting_packages.count; index++) {
        BTDataPackage *oldDataPackage = _writting_packages[index];
        if (oldDataPackage == dataPackage) {
            break;
        }
    }
    if (index < _writting_packages.count) {
        [_writting_packages replaceObjectAtIndex:index withObject:dataPackage];
    } else {
        [_writting_packages addObject:dataPackage];
    }
    [_writting_packages_lock unlock];
}


#pragma Private Methods
- (void)_stop
{
    [self.cbCentralManager stopScan];
    
    [_scanningTimer invalidate];
    [_connectingTimer invalidate];
    [_writtingTimer invalidate];
    
    _scanningTimer = nil;
    _connectingTimer = nil;
    _writtingTimer = nil;
    
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
    
    _connectingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runPeripheralConnectionJob:) userInfo:nil repeats:YES];
    _scanningTimer = [NSTimer timerWithTimeInterval:30.0f target:self selector:@selector(runCentralManagerScanningJob:) userInfo:nil repeats:YES];
    _writtingTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(runWrittingJob:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_scanningTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_connectingTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop mainRunLoop] addTimer:_writtingTimer forMode:NSDefaultRunLoopMode];
}

- (void)readCharacteristicWithServiceUUIDString:(NSString *)serviceUUIDString characteristicUUIDString:(NSString *)characteristicUUIDString
{
    dispatch_async(_characteristic_reading_queue, ^{
        [_connected_peripherals_lock lock];
        NSArray *connectedPeripherals = [[_connected_peripherals allValues] copy];
        [_connected_peripherals_lock unlock];
        
        CBService *service = nil;
        CBPeripheral *connectedPeripheral = nil;
        for (CBPeripheral *peripheral in connectedPeripherals) {
            service = [peripheral serviceWithUUIDString:serviceUUIDString];
            if (service) {
                connectedPeripheral = peripheral;
                break;
            }
        }
        
        if (connectedPeripheral && service) {
            CBCharacteristic *characteristic = [service characteristicWithCharacteristicUUIDString:characteristicUUIDString];
            if (characteristic) {
                [connectedPeripheral readValueForCharacteristic:characteristic];
            }
        }
    });
}

#pragma mark Timer Job
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
            [_discoveried_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
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

- (void)runWrittingJob:(NSTimer *)timer
{
    dispatch_async(_characteristic_writting_queue, ^{
        BTDataPackage *dataPackage = nil;
        [_writting_packages_lock lock];
        if (_writting_packages.count > 0) {
            dataPackage = _writting_packages.firstObject;
            [_writting_packages removeObjectAtIndex:0];
        }
        [_writting_packages_lock unlock];
        
        if (!dataPackage) {
            return ;
        }

        [_connected_peripherals_lock lock];
        NSArray *connectedPeripherals = [[_connected_peripherals allValues] copy];
        [_connected_peripherals_lock unlock];
        
        CBService *service = nil;
        CBPeripheral *connectedPeripheral = nil;
        for (CBPeripheral *peripheral in connectedPeripherals) {
            service = [peripheral serviceWithUUIDString:dataPackage.serviceUUIDString];
            if (service) {
                connectedPeripheral = peripheral;
                break;
            }
        }
        
        
        BOOL success = NO;
        if (connectedPeripheral && service) {
            for (CBCharacteristic *writeCharacteristic in service.characteristics) {
                if ([[_serviceCharacteristicMapper writeCharacteristicUUIDsForServiceUUIDString:service.UUID.UUIDString] containsObject:writeCharacteristic.UUID]) {
                    [connectedPeripheral writeValue:[dataPackage dataPackageSendingBytesData] forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
                    success = YES;
                    break;
                }
            }
        }
        
        if (!success) {
            [_writting_packages_lock lock];
            [_writting_packages addObject:dataPackage];
            [_writting_packages_lock unlock];
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
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([[_serviceCharacteristicMapper readCharacteristicUUIDsForServiceUUIDString:service.UUID.UUIDString] containsObject:characteristic.UUID]) {
            [self readCharacteristicWithServiceUUIDString:service.UUID.UUIDString characteristicUUIDString:characteristic.UUID.UUIDString];
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

    BTDataPackage *readingPackage = [characteristic.value dataPackage];
    readingPackage.serviceUUIDString = characteristic.service.UUID.UUIDString;
    readingPackage.readingCharacteristicsUUIDString = characteristic.service.UUID.UUIDString;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([self.delegate respondsToSelector:@selector(bluetoothManager:didReceiveDataPackage:)]) {
            [self.delegate bluetoothManager:self didReceiveDataPackage:readingPackage];
        }
    }];
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
