//
//  NSDictionary+LNType.m
//  SoYoungMobile
//
//  Created by Levin on 9/8/13.
//  Copyright (c) 2013 Millennium Dreamworks. All rights reserved.
//

#import "NSDictionary+JsonType.h"

@implementation NSDictionary (JsonType)
+ (NSNumber *)toNumber:(NSNumber *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        str = [NSNumber numberWithInteger:[(NSString *)str integerValue]];
    }
    return str;
}

- (NSString *)stringValueForKey:(NSString *)key
{
    NSString *str = [self objectForKey:key];
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    } else if ([str isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)str stringValue];
    }
    return nil;
}
- (NSNumber *)numberValueForKey:(NSString *)key
{
    NSNumber *num = [self.class toNumber:[self objectForKey:key]];
    if ([num isKindOfClass:[NSNumber class]]) {
        return num;
    }
    return nil;
}
@end
