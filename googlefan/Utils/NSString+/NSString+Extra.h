//
//  NSString+Extra.h
//  Roosher
//
//  Created by shenjianguo on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

@interface NSString (Extra)

+ (NSString*)stringWithNewUUID;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end
