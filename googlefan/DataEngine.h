//
//  DataEngine.h
//  Labixiaoxin1-5
//
//  Created by 晋辉 卫 on 5/1/12.
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface DataEngine : NSObject
{
    BOOL _hasRetinaDisplay;
    AFHTTPRequestOperationManager *_afNormalManager;
    AFNetworkReachabilityManager *_afNetworkReachabilityManager;
    NSMutableArray *_dispatchedOperations;
}

+ (DataEngine *)sharedInstance;
@property (strong, nonatomic) dispatch_queue_t ioQueue;

@property (strong, nonatomic) AFHTTPRequestOperationManager *afNormalManager;
@property (readonly, strong, nonatomic) NSDictionary *defaultHeaders;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *serverVersion;
@property (strong, nonatomic) NSString *venderUniqueId;
@property (strong, nonatomic, readonly) NSString *advertisingUniqueId;
@property (strong, nonatomic, readonly) NSString *platformString;
@property (strong, nonatomic) NSString *device_id;

#pragma mark - global funs
- (void)cancelRequests:(NSArray *)operations;

#pragma mark - local data
+ (NSDictionary *)makeRequestParam:(NSString *)method
                         withParam:(NSDictionary *)param;

#pragma mark - Login
- (NSOperation *)loginByEmailAccount:(NSNumber *)source
                           withEmail:(NSString *)email
                        withPassword:(NSString *)password
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMsg))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
