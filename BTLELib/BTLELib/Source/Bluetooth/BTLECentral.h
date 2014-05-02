//
//  BTLECentral.h
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTLEObject.h"


@protocol BTLECentralDelegate <NSObject>
-(void)didConnectToPeripheral:(CBPeripheral *)peripheral;
-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral;
-(void)receiveDataProgress:(float)progress;
-(void)didReceiveData:(NSData *)data;
@end


typedef enum : NSInteger {
    BTLECentralDataSendTypeUnknown = -1,
    
    // The default, sends data as 20-byte chunks via a queue
    BTLECentralDataSendTypeQueuedChunks,
    
    // Sends a single package of <= 20 bytes
    BTLECentralDataSendTypeDirect,
} BTLECentralDataSendType;


@interface BTLECentral : BTLEObject
@property (weak, nonatomic) id<BTLECentralDelegate> delegate;
@property BTLECentralDataSendType dataSendType; // Defaults to BTLECentralDataSendTypeDirect
@end
