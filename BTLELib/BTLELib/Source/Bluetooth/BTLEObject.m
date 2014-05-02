//
//  BTLECommon.m
//  BTLELib
//
//  Created by Keith Ermel on 3/23/14.
//  Copyright (c) 2014 Keith Ermel. All rights reserved.
//

#import "BTLEObject.h"


NSString *const kStartOfMessageText         = @"#SOM#";
NSString *const kStartSeparatorText         = @":";
NSString *const kEndOfMessageText           = @"#EOM#";

NSUInteger const kMaxChunkSize              = 20; // bytes


@implementation BTLEObject

-(id)initWithCharacteristicUUID:(NSString *)characteristicUUID
                    serviceUUID:(NSString *)serviceUUID
{
    self = [super init];
    
    if (self) {
        _characteristicUUID = characteristicUUID;
        _serviceUUID = serviceUUID;
    }
    
    return self;
}

@end
