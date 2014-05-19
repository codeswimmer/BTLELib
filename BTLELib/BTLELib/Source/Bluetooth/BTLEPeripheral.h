//
//  BTLEPeripheral.h
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTLEObject.h"

/**
 The `BTLEPeripheralDelegate` protocol defines a set of methods that you can use to receive
 `BTLEPeripheral` events.
 */
@protocol BTLEPeripheralDelegate <NSObject>
/**
 Indicates the peripheral has subscribed to a characteristic
 @param peripheral The peripheral that has subscribed
 @param characteristic The characteristic that was subscribed to
 */
-(void)peripheral:(CBPeripheralManager *)peripheral
     didSubscribe:(CBCharacteristic *)characteristic;

/**
 Indicates the peripheral has unsubscribed to a characteristic
 @param peripheral The peripheral that has unsubscribed
 @param characteristic The characteristic that was unsubscribed from
 */
-(void)peripheral:(CBPeripheralManager *)peripheral
   didUnsubscribe:(CBCharacteristic *)characteristic;

/**
 Indicates progress in sending data
 @param progress The current progress
 */
-(void)didSendDataChunk:(float)progress;

/** Indicates all data has been sent */
-(void)didFinishSendingData;
@end

/**
 `BTLEPeripheral` is a provider of data to a BTLECentral
 
 You initialize a `BTLEPeripheral` with characteristic and service UUIDs.
 */
@interface BTLEPeripheral : BTLEObject
/** The BTLEPeripheralDelegate object that handles BTLEPeripheral events. */
@property (weak, nonatomic) id<BTLEPeripheralDelegate> delegate;

/**
 Creates a `BTLEPeripheral` object.
 @param characteristicUUID The characteristic UUID
 @param serviceUUID The service UUID
 @return Returns the initialized object, or nil if an error occurs.
 */
-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID;

/**
 Initiates the sending of data to a BTLECentral
 @param data The data to be sent
 @param queue The queue used for sending the data
 */
-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue;

/**
 Sends an individual package of data (must be <= 20 bytes) to a BTLECentral
 @param data The data to be sent
 */
-(void)sendDataPackage:(NSData *)data;

/** Indicates the peripheral should stop advertising */
-(void)stopAdvertising;
@end
