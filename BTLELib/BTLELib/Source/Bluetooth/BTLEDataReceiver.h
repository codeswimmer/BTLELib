//
//  BTLEDataReceiver.h
//  BTLELib
//
//  Created by Keith Ermel on 3/27/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `BTLEDataReceiverDelegate` protocol defines a set of methods that you can use to receive
 `BTLEDataReceiver` events.
 */
@protocol BTLEDataReceiverDelegate <NSObject>

/**
 Indicates the all data has been received
 @param data The received data
 @param peripheral The peripheral that sent the data
 @param characteristic The characteristic associated with the data
 */
-(void)didCompleteReceivingData:(NSData *)data
                 fromPeripheral:peripheral
             withCharacteristic:characteristic;

@optional
/**
 Indicates current progress of data reception
 @param progress The current data reception progress
 */
-(void)receiveDataProgress:(float)progress;
@end

/**
 `BTLEDataReceiver` oversees the reception of data from a peripheral
 
 You initialize given a BTLEDataReceiverDelegate.
 */

@interface BTLEDataReceiver : NSObject
/** The BTLEDataReceiverDelegate object that handles BTLEDataReceiver events. */
@property (weak, readonly) id<BTLEDataReceiverDelegate> delegate;


/**
 Creates a `BTLEDataReceiver` object.
 @param delegate The BTLEDataReceiverDelegate that will receive events from the BTLEDataReceiver.
 @return Returns the initialized object, or nil if an error occurs.
 */
-(id)initWithDelegate:(id<BTLEDataReceiverDelegate>)delegate;

/**
 Indicates a chunk of data has been received
 @param data The chunk of data received
 @param peripheral The peripheral that sent the data
 @param characteristic The characteristic associated with the data
 */
-(void)didReceiveData:(NSData *)data
       fromPeripheral:peripheral
   withCharacteristic:characteristic;
@end
