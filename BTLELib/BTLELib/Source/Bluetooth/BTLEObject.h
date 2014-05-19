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

/**
 `BTLEObject` is an abstract class that serves as common base for BTLECentral and BTLEPeripheral
 
 You should not instantiate a BTLEObject; it is used interally by the `BTLELib` framework.
 */
@interface BTLEObject : NSObject
/** The characteristic UUID  */
@property (strong, readonly) NSString *characteristicUUID;

/** The service UUID  */
@property (strong, readonly) NSString *serviceUUID;

/**
 Creates a `BTLEObject`
 @param characteristicUUID The characteristic UUID for this object
 @param serviceUUID The service UUID for this object
 @return Returns the initialized object, or nil if an error occurs.
 */
-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID;
@end
