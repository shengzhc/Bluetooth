//
//  BTBluetoothManager.m
//  Bluetooth
//
//  Created by Shengzhe Chen on 4/22/15.
//  Copyright (c) 2015 Shengzhe Chen. All rights reserved.
//

#import "BTBluetoothManager.h"

@interface BTBluetoothManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager *cbCentralManager;
@end

@implementation BTBluetoothManager
{
    dispatch_queue_t _central_queue;
    NSMutableDictionary *_discoveried_peripherals;
    NSMutableDictionary *_connected_peripherals;
    
    NSLock *_discoveried_peripherals_lock;
    NSLock *_connected_peripherals_lock;
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
        _central_queue = dispatch_queue_create("com.bluetooth.centralmanager", DISPATCH_QUEUE_CONCURRENT);
        self.cbCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_central_queue options:nil];
        
        _discoveried_peripherals = [[NSMutableDictionary alloc] init];
        _discoveried_peripherals_lock = [[NSLock alloc] init];
        
        _connected_peripherals = [[NSMutableDictionary alloc] init];
        _connected_peripherals_lock = [[NSLock alloc] init];
    }
    
    return self;
}

- (void)start
{
    [self.cbCentralManager scanForPeripheralsWithServices:[self supportedPeripheralServices] options:nil];
}

- (void)stop
{
    [self.cbCentralManager stopScan];
    for (CBPeripheral *peripheral in _discoveried_peripherals.allValues) {
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.cbCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    for (CBPeripheral *peripheral in _connected_peripherals.allValues) {
        if (peripheral.state != CBPeripheralStateDisconnected) {
            [self.cbCentralManager cancelPeripheralConnection:peripheral];
        }
    }
    [_discoveried_peripherals_lock lock];
    [_discoveried_peripherals removeAllObjects];
    [_discoveried_peripherals_lock unlock];
    
    [_connected_peripherals_lock lock];
    [_connected_peripherals removeAllObjects];
    [_connected_peripherals_lock unlock];
}

- (NSArray *)supportedPeripheralServices
{
    static NSArray *services = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        services = @[[CBUUID UUIDWithString:@"1890"]
                     ];
    });
    return services;
}

#pragma mark CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"centralManagerDidUpdateState: %ld", (long)central.state];
    NSLog(@"%@", log);
#endif
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDiscoverPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    NSLog(@"%@", log);
#endif
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_discoveried_peripherals_lock lock];
        [_discoveried_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
        [_discoveried_peripherals_lock unlock];
        [self.cbCentralManager connectPeripheral:peripheral options:nil];
    }];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didConnectPeripheral: %@, %@", peripheral.name, peripheral.identifier.UUIDString];
    NSLog(@"%@", log);
#endif
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [_connected_peripherals_lock lock];
        [_connected_peripherals setObject:peripheral forKey:peripheral.identifier.UUIDString];
        [_connected_peripherals_lock unlock];
        
        [_discoveried_peripherals_lock lock];
        [_discoveried_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
        [_discoveried_peripherals_lock unlock];
        
        NSMutableArray *discoverServices = [[self supportedPeripheralServices] mutableCopy];
        
        for (CBService *service in peripheral.services) {
            if ([discoverServices containsObject:service.UUID]) {
                [discoverServices removeObject:service.UUID];
            }
        }
        peripheral.delegate = self;
        [peripheral discoverServices:discoverServices];
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didFailToConnectPeripheral: %@, %@, %@", peripheral.name, peripheral.identifier.UUIDString, error];
    NSLog(@"%@", log);
#endif
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSString *log = [NSString stringWithFormat:@"didDisconnectPeripheral: %@, %@, %@", peripheral.name, peripheral.identifier.UUIDString, error];
    NSLog(@"%@", log);
#endif
    peripheral.delegate = nil;
    [_connected_peripherals_lock lock];
    [_connected_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_connected_peripherals_lock unlock];
    
    [_discoveried_peripherals_lock lock];
    [_discoveried_peripherals removeObjectForKey:peripheral.identifier.UUIDString];
    [_discoveried_peripherals_lock unlock];
}

@end
