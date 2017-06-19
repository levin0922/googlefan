//
//  JsonUtils.m
//  ComicLover~iPad
//
//  Created by Rena Wong on 14-1-14.
//  Copyright (c) 2014年 Levin Wei. All rights reserved.
//

#import "JsonUtils.h"

@implementation JsonUtils

+ (id)JSONObjectWithData:(NSData *)data
{
    NSError *jsonParsingError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:&jsonParsingError];
    if (jsonParsingError == nil) {
        return jsonObject;
    }
    return nil;
}

+ (NSString *)StringWithJSONObject:(id)object
{
    NSError *jsonParsingError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:0
                                                     error:&jsonParsingError];
    if (jsonParsingError == nil) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
