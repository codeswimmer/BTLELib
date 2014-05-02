//
//  BTLECommon.h
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;


extern NSString *const kStartOfMessageText;
extern NSString *const kStartSeparatorText;
extern NSString *const kEndOfMessageText;

extern NSUInteger const kMaxChunkSize;


@interface BTLEObject : NSObject
@property (strong, readonly) NSString *characteristicUUID;
@property (strong, readonly) NSString *serviceUUID;

-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID;
@end
