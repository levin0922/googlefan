//
//  NSString+Extra.m
//  Roosher
//
//  Created by shenjianguo on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

#import "NSString+Extra.h"

@implementation NSString (Extra)


+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    NSString *result = CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(uuidObj);
    CFRelease(uuidString);
    return result;
}

- (NSString *)URLEncodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
	return result;
}

- (NSString*)URLDecodedString {
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
	return result;	
}

@end
