//
//  BTLECentral.m
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "BTLECentral.h"
#import "BTLEDataReceiver.h"


@interface BTLECentral ()<CBCentralManagerDelegate, CBPeripheralDelegate, BTLEDataReceiverDelegate>
@property (strong, readonly, nonatomic) CBCentralManager *centralManager;
@property (strong) CBPeripheral *sendingPeripheral;
@property (strong) BTLEDataReceiver *dataReceiver;
@end


@implementation BTLECentral

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"central ON");
        [self startScanningForPeripherals];
    }
    else if (central.state == CBCentralManagerStatePoweredOff) {
        NSLog(@"central OFF");
        [self stopScanningForPeripherals];
    }
}

-(void)centralManager:(CBCentralManager *)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData
                 RSSI:(NSNumber *)RSSI
{
    if (self.sendingPeripheral != peripheral) {
        NSLog(@"Discovered %@ at %@", peripheral.identifier.UUIDString, RSSI);
        self.sendingPeripheral = peripheral;
        
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral: %@", peripheral);
    
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    _dataReceiver = [[BTLEDataReceiver alloc] initWithDelegate:self];
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:self.serviceUUID]]];
    
    [self.delegate didConnectToPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"<-- disconnected from: %@ [%@]", peripheral.name, error);
    
    [self.delegate didDisconnectFromPeripheral:peripheral];
}


#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices: %@", peripheral.services);
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:self.characteristicUUID]]
                                 forService:service];
    }
}

                  - (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
                               error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.characteristicUUID]]) {
            NSLog(@"subscribed to characteristic: %@", characteristic);
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

             - (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
                          error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    if (self.dataSendType == BTLECentralDataSendTypeDirect) {
        [self.delegate didReceiveData:characteristic.value];
    }
    else {
        [self.dataReceiver didReceiveData:characteristic.value
                           fromPeripheral:peripheral
                       withCharacteristic:characteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"didModifyServices: %@", invalidatedServices);
}


#pragma mark - BTLEDataReceiverDelegate

-(void)receiveDataProgress:(float)progress
{
    [self.delegate receiveDataProgress:progress];
}

-(void)didCompleteReceivingData:(NSData *)data
                 fromPeripheral:peripheral
             withCharacteristic:characteristic
{
    [self.delegate didReceiveData:data];
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    [self.centralManager cancelPeripheralConnection:peripheral];
}


#pragma mark - Internal API

-(void)startScanningForPeripherals
{
    NSLog(@"scanning for peripheral");
    CBUUID *uuid = [CBUUID UUIDWithString:self.serviceUUID];
    [self.centralManager scanForPeripheralsWithServices:@[uuid]
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
}

-(void)stopScanningForPeripherals
{
    NSLog(@"stopping scanning for peripheral");
    [self.centralManager stopScan];
}


#pragma mark - Initialization

-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID
{
    self = [super initWithCharacteristicUUID:characteristicUUID serviceUUID:serviceUUID];
    
    if (self) {
        self.dataSendType = BTLECentralDataSendTypeQueuedChunks;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:queue];
    }
    
    return self;
}

@end
