//
//  NSDictionary+LNType.h
//  SoYoungMobile
//
//  Created by Levin on 9/8/13.
//  Copyright (c) 2013 Millennium Dreamworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonType)
+ (NSNumber *)toNumber:(NSNumber *)str;

- (NSString *)stringValueForKey:(NSString *)key;
- (NSNumber *)numberValueForKey:(NSString *)key;
@end
