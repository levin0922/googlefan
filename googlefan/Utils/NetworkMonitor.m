//
//  NetworkMonitor.m
//  ThreeHundred
//
//  Created by skye on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkMonitor.h"

@interface NetworkMonitor(Private)

- (void) reachabilityCheck;
- (void) reachabilityDoubleCheck;
- (void) reachabilityChanged: (NSNotification *)note;
- (BOOL) updateInterfaceWithReachability: (Reachability *)curReach;

@end

@implementation NetworkMonitor

@synthesize networkStatus = _networkStatus;

static NetworkMonitor * _sharedInstance = nil;

+ (NetworkMonitor *)sharedInstance
{
	if ( _sharedInstance == nil ) {
		_sharedInstance = [[NetworkMonitor alloc] init];
	}
	return _sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NetworkStatus)status
{
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

- (void)start
{    
    networkReachable = YES;
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    networkReachable = [self updateInterfaceWithReachability:internetReach];
    [self reachable];
    [internetReach startNotifier];
}

- (BOOL)reachable
{
    if (!networkReachable && _showingAlert == nil) {
//        NSString *statusString = NSLocalizedString(@"No working Internet connection is found.\r\nIf WiFi is enable, try disabling WiFi or try another WiFi hotspot.", @"");
        NSString *statusString = NSLocalizedString(@"没有找到可用网络，请尝试断开连接后重新连接😄", @"");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"网络连接断开!", @"")
                                                        message:statusString
                                                       delegate:self 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];   
        _showingAlert = alert;
        [alert show];
    }
    return networkReachable;
}

- (BOOL)updateInterfaceWithReachability:(Reachability *)curReach
{
    BOOL reachable = NO;
    self.networkStatus = [curReach currentReachabilityStatus];
#ifdef DEBUG
    NSString *statusString = @"";
    switch (self.networkStatus) {
        case NotReachable: {
            statusString = @"Access Not Available";
            reachable = NO;
            break;
        }
        case ReachableViaWWAN: {
            statusString = @"Reachable WWAN";
            reachable = YES;
            break;
        }
        case ReachableViaWiFi: {
            statusString = @"Reachable WiFi";
            reachable = YES;
            break;
        }
    }
    MSLog(@"network status : %@ %@", [curReach description], statusString);
#endif
    return reachable;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification *)note
{
	Reachability *curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	networkReachable = [self updateInterfaceWithReachability: curReach];
    [self reachable];
    
    if (networkReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkReachable" object:nil];        
    }
}

#pragma mark - 商品接口

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _showingAlert = nil;
}

@end
