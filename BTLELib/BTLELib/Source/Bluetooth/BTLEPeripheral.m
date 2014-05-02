//
//  BTLEPeripheral.m
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "BTLEPeripheral.h"
#import "BTLEDataSender.h"
#import "Luokat/NSMutableArray+Queue.h"


@interface BTLEPeripheral ()<CBPeripheralManagerDelegate, CBPeripheralDelegate, BTLEDataSenderDelegate>
@property (strong, readonly) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic) BTLEDataSender *dataSender;
@end


@implementation BTLEPeripheral

#pragma mark - Public API

-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue
{
    [self.dataSender beginSendingData:data queue:queue];
}

-(void)sendDataPackage:(NSData *)data
{
    [self sendDataChunk:data];
}


#pragma mark - Internal API

-(void)startAdvertising
{
    NSLog(@"startAdvertising");
    CBUUID *uuid = [CBUUID UUIDWithString:self.serviceUUID];
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[uuid]}];
}

-(void)stopAdvertising
{
    NSLog(@"stopAdvertising");
    [self.peripheralManager stopAdvertising];
}


#pragma mark - BTLEDataSenderDelegate

-(BOOL)sendDataChunk:(NSData *)chunk
{
    return [self.peripheralManager updateValue:chunk
                             forCharacteristic:self.transferCharacteristic
                          onSubscribedCentrals:nil];
}

-(void)didSendDataChunk:(float)progress
{
    [self.delegate didSendDataChunk:progress];
}

-(void)dataSendCompleted
{
    [self.delegate didFinishSendingData];
}


#pragma mark - CBPeripheralManagerDelegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheral ON");
        [self configureTransferCharacteristic];
        [self configureTransferService];
        [self startAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"peripheral OFF");
        [self stopAdvertising];
    }
}


#pragma mark - CBPeripheralDelegate

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"peripheral.services: %@", peripheral.services);
    for (CBService *service in peripheral.services) {
        NSLog(@"    service: %@", service.UUID.UUIDString);
    }
}

    -(void)peripheralManager:(CBPeripheralManager *)peripheral
                     central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didSubscribeToCharacteristic\n  peripheral: %@\n  central: %@\n  characteristic: %@",
          peripheral, central, characteristic);
    
    [self.delegate peripheral:peripheral didSubscribe:characteristic];
}

        -(void)peripheralManager:(CBPeripheralManager *)peripheral
                         central:(CBCentral *)central
didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didUnsubscribeFromCharacteristic\n  peripheral: %@\n  central: %@\n  characteristic: %@",
          peripheral, central, characteristic);
    
    [self.delegate peripheral:peripheral didUnsubscribe:characteristic];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    [self.dataSender sendNextChunk];
}


#pragma mark - Configuration

-(void)configureTransferCharacteristic
{
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:self.characteristicUUID];
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
}

-(void)configureTransferService
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:self.serviceUUID];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:serviceUUID
                                                                       primary:YES];
    transferService.characteristics = @[self.transferCharacteristic];
    [self.peripheralManager addService:transferService];
}


#pragma mark - Initialization

-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID
{
    self = [super initWithCharacteristicUUID:characteristicUUID serviceUUID:serviceUUID];
    
    if (self) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:queue];
        _dataSender = [[BTLEDataSender alloc] initWithDelegate:self];
    }
    
    return self;
}

@end
