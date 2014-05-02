//
//  BTLESender.h
//  BTLELib
//
//  Created by Keith Ermel on 3/26/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BTLEDataSenderDelegate <NSObject>
-(BOOL)sendDataChunk:(NSData *)chunk;

@optional
-(void)didSendDataChunk:(float)progress;
-(void)dataSendCompleted;

@end


@interface BTLEDataSender : NSObject
@property (weak, readonly) id<BTLEDataSenderDelegate> delegate;
-(id)initWithDelegate:(id<BTLEDataSenderDelegate>)delegate;
-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue;
-(void)sendNextChunk;
@end
