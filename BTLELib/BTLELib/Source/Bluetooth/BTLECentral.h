//
//  BTLECentral.h
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTLEObject.h"

/**
 The `BTLECentralDelegate` protocol defines a set of methods that you can use to receive
 `BTLECentral` events.
 */
@protocol BTLECentralDelegate <NSObject>
/**
 Indicates the central has connected to a peripheral
 @param peripheral The peripheral that was connected to
 */
-(void)didConnectToPeripheral:(CBPeripheral *)peripheral;

/**
 Indicates the central has disconnected from a peripheral
 @param peripheral The peripheral that was disconnected from
 */
-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral;

/**
 Indicates progress on the reception of data
 @param progress The current progress
 */
-(void)receiveDataProgress:(float)progress;

/**
 Indicates the completion of data reception
 @param data The data that was received
 */
-(void)didReceiveData:(NSData *)data;
@end

/**
 `BTLECentralDataSendType` specifies whether the `BTLECentral` implementation receives its data in
 queued chunks, or as direct single-shot packages.
 */
typedef NS_ENUM(NSInteger, BTLECentralDataSendType){
    /** Send type has not been determined */
    BTLECentralDataSendTypeUnknown = -1,
    
    /** Sends data as 20-byte chunks via a queue */
    BTLECentralDataSendTypeQueuedChunks,
    
    /** The default, sends a single package of <= 20 bytes */
    BTLECentralDataSendTypeDirect,
};

/**
 `BTLECentral` is a consumer of data from a BTLEPeripheral
 */

@interface BTLECentral : BTLEObject
/** The BTLECentralDelegate object that handles BTLECentral events. */
@property (weak, nonatomic) id<BTLECentralDelegate> delegate;
/** 
 Indicates the manner in which data is to be received
 
 Defaults to BTLECentralDataSendTypeDirect
 */
@property BTLECentralDataSendType dataSendType;
@end
