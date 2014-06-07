//
//  ReceiverViewController.m
//  BTLELibExample
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "ReceiverViewController.h"
#import "AppUUIDs.h"
#import "BTLELib/BTLECentral.h"


@interface ReceiverViewController ()<BTLECentralDelegate> {
    UIColor *connectedColor;
    UIColor *disconnectedColor;
}
@property (strong, readonly) BTLECentral *central;

// Outlets
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *connectionStatus;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end


@implementation ReceiverViewController

#pragma mark - BTLECentralDelegate

-(void)didConnectToPeripheral:(CBPeripheral *)peripheral
{
    dispatch_async(dispatch_get_main_queue(), ^{self.connectionStatus.backgroundColor = connectedColor;});
}

-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral
{
    dispatch_async(dispatch_get_main_queue(), ^{self.connectionStatus.backgroundColor = disconnectedColor;});

}

-(void)receiveDataProgress:(float)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{self.progressView.progress = progress;});

}

-(void)didReceiveData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.textView.text = text;
        self.statusLabel.text = [NSString stringWithFormat:@"%d bytes received", (int)text.length];
    });
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _central = [[BTLECentral alloc] initWithCharacteristicUUID:kTransferCharacteristicUUID
                                                   serviceUUID:kTransferServiceUUID];
    self.central.delegate = self;
    
    /* 008000FF */
    connectedColor = [UIColor colorWithRed:0x00/255.0 green:0x80/255.0 blue:0x00/255.0 alpha:0xFF/255.0];
    
    /* 790002FF */
    disconnectedColor = [UIColor colorWithRed:0x79/255.0 green:0x00/255.0 blue:0x02/255.0 alpha:0xFF/255.0];
}

@end
