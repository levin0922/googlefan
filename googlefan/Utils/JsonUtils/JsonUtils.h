//
//  JsonUtils.h
//  ComicLover~iPad
//
//  Created by Rena Wong on 14-1-14.
//  Copyright (c) 2014年 Levin Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtils : NSObject

+ (id)JSONObjectWithData:(NSData *)data;
+ (NSString *)StringWithJSONObject:(id)object;

@end
