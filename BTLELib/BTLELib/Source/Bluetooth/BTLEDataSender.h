//
//  BTLESender.h
//  BTLELib
//
//  Created by Keith Ermel on 3/26/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The `BTLEDataSenderDelegate` protocol defines a set of methods that you can use to receive
 `BTLEDataSender` events.
 */
@protocol BTLEDataSenderDelegate <NSObject>
/**
 Indicates the sending object should send a chunk of data
 @param chunk The data to be sent
 @return `YES` if the data was successfully sent
 */
-(BOOL)sendDataChunk:(NSData *)chunk;

@optional
/**
 Indicates progress on sending data
 @param progress The current send data progress
 */
-(void)didSendDataChunk:(float)progress;

/** Indicates all data has been sent */
-(void)dataSendCompleted;
@end

/**
 `BTLEDataSender` oversees the sending of data to a BTLEDataReceiver
 
 You instantiate a BTLEDataSender by providing a BTLEDataSenderDelegate
 */
@interface BTLEDataSender : NSObject
/** The BTLEDataSenderDelegate object that handles BTLEDataSender events. */
@property (weak, readonly) id<BTLEDataSenderDelegate> delegate;

/**
 Creates a `BTLEDataSender` object.
 @param delegate The BTLEDataSenderDelegate that will receive events from the BTLEDataSender.
 @return Returns the initialized object, or nil if an error occurs.
 */
-(id)initWithDelegate:(id<BTLEDataSenderDelegate>)delegate;

/**
 Initiates the queued sending of data
 @param data The data to be sent
 @param queue The queue to use for sending the data
 */
-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue;

/** Indicates the next chunk of data should be sent */
-(void)sendNextChunk;
@end
