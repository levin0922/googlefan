//
//  DeviceHardware.h
//  phonebook
//
//  Created by shenjianguo on 11-1-24.
//  Copyright 2011 Roosher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (Hardware)

- (BOOL)hasRetinaDisplay;

- (BOOL)isiPhone4;
- (BOOL)isiPhone5;
- (BOOL)isiPhone6;
- (BOOL)isiPhone6p;
- (BOOL)isLongiPhone;

- (BOOL)hasMultitasking;

- (BOOL)hasCamera;

- (NSString *) macaddress;
- (NSString *)platformString;
- (NSString *)cusSystemName;
- (NSString *)venderString;
- (NSString *)resolutionString;
- (NSString *)currentNetType;
- (NSString *)currentNetworkingType;
- (NSString *)operatorCode;
- (NSString *)operatorName;

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

- (NSString *)freeSizeInStr;
@end

