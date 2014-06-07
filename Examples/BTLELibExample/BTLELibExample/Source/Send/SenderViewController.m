//
//  SenderViewController.m
//  BTLELibExample
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "SenderViewController.h"
#import "AppUUIDs.h"
#import "BTLELib/BTLEPeripheral.h"


const char* kSendQueueName  = "com.keithermel.btle.send.queue";


@interface SenderViewController ()<BTLEPeripheralDelegate> {
    UIColor *connectedColor;
    UIColor *disconnectedColor;
}
@property (strong, readonly) BTLEPeripheral *peripheral;
@property (strong, readonly) dispatch_queue_t sendQueue;
@property NSUInteger totalToBeSent;

// Outlets
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *connectionStatus;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end


@implementation SenderViewController

#pragma mark - BTLEPeripheralDelegate

-(void)peripheral:(CBPeripheralManager *)peripheral
     didSubscribe:(CBCharacteristic *)characteristic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectionStatus.backgroundColor = connectedColor;
        self.sendButton.enabled = YES;
    });
}

-(void)peripheral:(CBPeripheralManager *)peripheral
   didUnsubscribe:(CBCharacteristic *)characteristic
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.connectionStatus.backgroundColor = disconnectedColor;
        self.sendButton.enabled = NO;
    });
}

-(void)didSendDataChunk:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        float value = ((float)progress / 100.0);
        NSLog(@"progress: %3.2f", value);
        self.progressView.progress = value;
    });
}

-(void)didFinishSendingData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStatusLabel];
        [self.navigationController popViewControllerAnimated:YES];
        self.statusLabel.text = [NSString stringWithFormat:@"%d bytes added", (int)self.totalToBeSent];
    });
}


#pragma mark - Internal API

-(void)updateStatusLabel
{
    unsigned long numBytes = (unsigned long)self.textView.text.length;
    self.statusLabel.text = [NSString stringWithFormat:@"Sent %ld bytes", numBytes];
}

-(void)fillTextWithText
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *text = @"";
        
        NSString *pad = @"abcdefghijklmn\n";
        int max = 1 * 1000;
        for (int i = 0; i < max; i++) {
            NSString *chunk = [NSString stringWithFormat:@"%05d%@", i, pad];
            text = [text stringByAppendingString:chunk];
            
            if (i % 100 == 0) {
                NSLog(@"%i", (int)i);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = text;
            self.statusLabel.text = [NSString stringWithFormat:@"%d bytes added", (int)self.textView.text.length];
        });
    });
}


#pragma mark - Actions

-(IBAction)sendAction:(id)sender
{
    self.sendButton.enabled = NO;
    self.totalToBeSent = self.textView.text.length;
    self.statusLabel.text = [NSString stringWithFormat:@"Sending %d bytes", (int)self.totalToBeSent];
    
    [self.peripheral beginSendingData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding]
                                queue:self.sendQueue];
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fillTextWithText];
    
    _peripheral = [[BTLEPeripheral alloc] initWithCharacteristicUUID:kTransferCharacteristicUUID
                                                         serviceUUID:kTransferServiceUUID];
    self.peripheral.delegate = self;
    
    _sendQueue = dispatch_queue_create(kSendQueueName,  DISPATCH_QUEUE_SERIAL);
    
    /* 008000FF */
    connectedColor = [UIColor colorWithRed:0x00/255.0 green:0x80/255.0 blue:0x00/255.0 alpha:0xFF/255.0];
    
    /* 790002FF */
    disconnectedColor = [UIColor colorWithRed:0x79/255.0 green:0x00/255.0 blue:0x02/255.0 alpha:0xFF/255.0];
}

@end
