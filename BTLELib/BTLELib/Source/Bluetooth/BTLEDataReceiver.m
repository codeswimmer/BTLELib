//
//  BTLEDataReceiver.m
//  BTLELib
//
//  Created by Keith Ermel on 3/27/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "BTLEDataReceiver.h"
#import "BTLEObject.h"


@interface BTLEDataReceiver ()
@property (strong) NSMutableData *data;
@property NSInteger totalDataLength;
@property NSInteger amountReceived;
@end


@implementation BTLEDataReceiver

#pragma mark - Public API

-(void)didReceiveData:(NSData *)receivedData
       fromPeripheral:peripheral
   withCharacteristic:characteristic
{
    
    NSString *messageText = [[NSString alloc] initWithData:receivedData
                                                  encoding:NSUTF8StringEncoding];
    
    if ([self isStartOfMessage:messageText]) {
        [self determineTotalDataLength:messageText];
        NSLog(@"self.totalDataLength: %d", (int)self.totalDataLength);
    }
    else if ([self isEndOfMessage:messageText]) {
        NSLog(@"EOM received");
        [self.delegate didCompleteReceivingData:self.data
                                 fromPeripheral:peripheral
                             withCharacteristic:characteristic];
    }
    else {
        [self.data appendData:receivedData];
        self.amountReceived += messageText.length;
    }

    float progress = [self notifyDelegateReceiveDataProgress];
    
    NSLog(@"Received: %@ (%d of %d %3.2f%%)",
          messageText, (int)self.amountReceived, (int)self.totalDataLength, progress * 100.0);
}


#pragma mark - Internal API

-(BOOL)isStartOfMessage:(NSString *)messageText
{
    NSLog(@"stringFromData: %@", messageText);
    NSRange startOfMessageRange = [messageText rangeOfString:kStartOfMessageText];
    if (startOfMessageRange.location != NSNotFound) {return YES;}
    return NO;
}

-(BOOL)isEndOfMessage:(NSString *)messageText
{
    return [messageText isEqualToString:kEndOfMessageText];
}

-(void)determineTotalDataLength:(NSString *)messageText
{
    NSRange startOfMessageRange = [messageText rangeOfString:kStartOfMessageText];
    if (startOfMessageRange.location != NSNotFound) {
        NSUInteger start = startOfMessageRange.location + kStartOfMessageText.length + kStartSeparatorText.length;
        NSUInteger length = messageText.length - start;
        NSLog(@"start: %d; length: %d", (int)start, (int)length);
        
        NSRange dataLengthRange = NSMakeRange(start, length);
        NSLog(@"dataLengthRange: %@", NSStringFromRange(dataLengthRange));
        
        NSString *dataLengthString = [messageText substringWithRange:dataLengthRange];
        NSLog(@"dataLengthString: %@", dataLengthString);
        
        self.totalDataLength = [dataLengthString integerValue];
    }
}

-(float)notifyDelegateReceiveDataProgress
{
    float progress = [self calculatePercentComplete];
    
    if ([self.delegate respondsToSelector:@selector(receiveDataProgress:)]) {
        [self.delegate receiveDataProgress:progress];
    }
    
    return progress;
}

-(float)calculatePercentComplete
{
    float total = (float)self.totalDataLength;
    float received = (float)self.amountReceived;
    return (received / total);
}


#pragma mark - Initialization

-(id)initWithDelegate:(id<BTLEDataReceiverDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _data = [[NSMutableData alloc] init];
        
        self.totalDataLength = 0;
        self.amountReceived = 0;
    }
    
    return self;
}

@end
