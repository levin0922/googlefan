//
//  DeviceHardware.m
//  phonebook
//
//  Created by shenjianguo on 11-1-24.
//  Copyright 2011 Roosher. All rights reserved.
//

#import "DeviceHardware.h"
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/sysctl.h>
#import "NSString+MD5.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface UIDevice (Private)
- (NSString *) platform;
- (NSString *) macaddress;
@end

@implementation UIDevice (Hardware)

- (NSString *)platform {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
#ifdef DEBUG
        printf("Error: if_nametoindex error\n");
#endif
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
#ifdef DEBUG
        printf("Error: sysctl, take 1\n");
#endif
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
#ifdef DEBUG
        printf("Could not allocate memory. error!\n");
#endif
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
#ifdef DEBUG
        printf("Error: sysctl, take 2");
#endif
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (BOOL)hasRetinaDisplay {
    BOOL ret = NO;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
        ret = YES;
    }
    return ret;
}

- (BOOL)isiPhone4
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        return MIN(screenSize.width, screenSize.height) == 320.0 && MAX(screenSize.width, screenSize.height) == 480.0;
    }
    return NO;
}

- (BOOL)isiPhone5
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        return MIN(screenSize.width, screenSize.height) == 320.0 && MAX(screenSize.width, screenSize.height) == 568.0;
    }
    return NO;
}

- (BOOL)isiPhone6
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        return MIN(screenSize.width, screenSize.height) == 375.0 && MAX(screenSize.width, screenSize.height) == 667.0;
    }
    return NO;
}

- (BOOL)isiPhone6p
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        return MIN(screenSize.width, screenSize.height) == 414.0 && MAX(screenSize.width, screenSize.height) == 736.0;
    }
    return NO;
}

- (BOOL)isLongiPhone
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat rate = MAX(screenSize.width, screenSize.height) * 100 / MIN(screenSize.width, screenSize.height);
        return (NSInteger)rate == 177;
    }
    return NO;
}

- (BOOL)hasMultitasking {
    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
        return [self isMultitaskingSupported];
    }
    return NO;
}

- (BOOL)hasCamera {
    BOOL ret = NO;
    // check camera availability
    return ret;
}

- (NSString *)platformString {
    NSString *platform = [self platform];
    return platform;
}

- (NSString *)cusSystemName
{
    return @"iPhone OS";
}

- (NSString *)venderString
{
    return @"Apple";
}

- (NSString *)resolutionString
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGSize mainSize = [[UIScreen mainScreen] bounds].size;
    int widthSize = (int)( mainSize.width * scale_screen);
    int heightSize = (int)( mainSize.height * scale_screen);
    return [NSString stringWithFormat:@"%d*%d", MIN(widthSize, heightSize), MAX(widthSize, heightSize)];
}

- (NSString *)currentNetType
{
    // zzNetworking
    NSString *network = @"0";
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] currentStatus];
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *tmp = [info.currentRadioAccessTechnology stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology"
                                                                                     withString:@""];
        network = tmp.length ? tmp : @"CellNetwork";
    } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        network = @"WiFi";
    }
    return network;
}

- (NSString *)currentNetworkingType
{
    // zzNetworkingType
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] currentStatus];
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
        NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
            return @"2G";
        }
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"] || [currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
            return @"3G";
        }
        
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
            return @"4G";
        }
    }
    
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"WiFi";
    }
    if (status == AFNetworkReachabilityStatusUnknown) {
        return @"";
    }
    return @"";
    
}

- (NSString *)operatorCode
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return [carrier.mobileCountryCode stringByAppendingString:carrier.mobileNetworkCode];
}

- (NSString *)operatorName
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    return carrier.carrierName;
}

- (NSString *) uniqueDeviceIdentifier {
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash md5];
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress md5];
    
    return uniqueIdentifier;
}

- (NSString *)freeSizeInStr
{
    NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:docsDir error:NULL];
    unsigned long long freeSpaceInBytes = [[fileAttributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    NSString *sizeStr = nil;
    unsigned long long size = freeSpaceInBytes / 1024;
    sizeStr = [NSString stringWithFormat:@"%lldK", size];
    if (size > 1024) {
        size = size / 1024;
        sizeStr = [NSString stringWithFormat:@"%lldM", size];
        if (size > 1024) {
            sizeStr = [NSString stringWithFormat:@"%0.2lfG", size / 1024.0];
        }
    }
    return sizeStr;
}
@end
