//
//  BTLESender.m
//  BTLELib
//
//  Created by Keith Ermel on 3/26/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "BTLEDataSender.h"
#import "BTLEObject.h"
#import "Luokat/NSMutableArray+Queue.h"


@interface BTLEDataSender ()
@property (strong) NSMutableArray *dataChunks;
@property NSUInteger numberOfChunksToSend;
@property NSUInteger numberOfChunksSent;
@end


@implementation BTLEDataSender

#pragma mark - Public API

-(void)beginSendingData:(NSData *)data queue:(dispatch_queue_t)queue
{
    dispatch_async(queue, ^{
        self.dataChunks = [self splitDataIntoChunks:data];
        self.numberOfChunksToSend = self.dataChunks.count;
        [self sendChunks];
    });
}

-(void)sendNextChunk
{
    [self sendChunks];
}


#pragma mark - Internal API


-(NSMutableArray *)splitDataIntoChunks:(NSData *)data
{
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSUInteger amount = kMaxChunkSize;
    NSUInteger total = data.length;
    
    NSString *startMessage = [NSString stringWithFormat:@"%@%@%ld",
                              kStartOfMessageText, kStartSeparatorText, (unsigned long)total];
    [chunks queuePush:[startMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    while (index < total) {
        NSData *chunk = [NSData dataWithBytes:data.bytes + index length:amount];
        [chunks queuePush:chunk];
        
        index += amount;
        amount = MIN(total - index, kMaxChunkSize);
    }
    
    [chunks queuePush:[kEndOfMessageText dataUsingEncoding:NSUTF8StringEncoding]];
    return chunks;
}

-(void)sendChunks
{
    BOOL didSend = YES;
    
    while (didSend && [self.dataChunks isNotEmpty]) {
        NSData *chunk = [self.dataChunks queuePeek];
        
        if ([self.delegate sendDataChunk:chunk]) {
            [self.dataChunks queuePop];
            self.numberOfChunksSent++;
            [self notifyDelegateDidSendChunk];
        }
        else {
            return;
        }
    }
}

-(void)notifyDelegateDidSendChunk
{
    float total = (float)self.numberOfChunksToSend;
    float sent = (float)self.numberOfChunksSent;
    float progress = (sent / total) * 100.0;
    
    if ([self.delegate respondsToSelector:@selector(didSendDataChunk:)]) {[self.delegate didSendDataChunk:progress];}
    
    if ([self allDataChunksSent]) {[self notifyDelegateSendCompleted];}
}

-(void)notifyDelegateSendCompleted
{
    if ([self.delegate respondsToSelector:@selector(dataSendCompleted)]) {[self.delegate dataSendCompleted];}
}

-(BOOL)allDataChunksSent
{
    return self.numberOfChunksSent >= self.numberOfChunksToSend;
}



#pragma mark - Initialization

-(id)initWithDelegate:(id<BTLEDataSenderDelegate>)delegate
{
    self = [super init];
    
    if (self) {_delegate = delegate;}
    
    return self;
}

@end
