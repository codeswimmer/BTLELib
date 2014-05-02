//
//  BTLEDataReceiver.h
//  BTLELib
//
//  Created by Keith Ermel on 3/27/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BTLEDataReceiverDelegate <NSObject>

-(void)didCompleteReceivingData:(NSData *)data
                 fromPeripheral:peripheral
             withCharacteristic:characteristic;

@optional
-(void)receiveDataProgress:(float)progress;
@end


@interface BTLEDataReceiver : NSObject
@property (weak, readonly) id<BTLEDataReceiverDelegate> delegate;

-(id)initWithDelegate:(id<BTLEDataReceiverDelegate>)delegate;
-(void)didReceiveData:(NSData *)data
       fromPeripheral:peripheral
   withCharacteristic:characteristic;
@end
