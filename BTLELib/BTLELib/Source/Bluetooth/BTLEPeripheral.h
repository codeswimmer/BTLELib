//
//  BTLEPeripheral.h
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTLEObject.h"


@protocol BTLEPeripheralDelegate <NSObject>
-(void)peripheral:(CBPeripheralManager *)peripheral
     didSubscribe:(CBCharacteristic *)characteristic;

-(void)peripheral:(CBPeripheralManager *)peripheral
   didUnsubscribe:(CBCharacteristic *)characteristic;

-(void)didSendDataChunk:(float)progress;
-(void)didFinishSendingData;
@end


@interface BTLEPeripheral : BTLEObject
@property (weak, nonatomic) id<BTLEPeripheralDelegate> delegate;

-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID;

-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue;

-(void)sendDataPackage:(NSData *)data;
-(void)stopAdvertising;
@end
