//
//  DataEngine.m
//  Labixiaoxin1-5
//
//  Created by 晋辉 卫 on 5/1/12.
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import "DataEngine.h"
#import <AdSupport/AdSupport.h>
#import "NSDictionary+JsonType.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "DeviceHardware.h"
#import "JsonUtils.h"
#import "NSString+MD5.mm"

@interface DataEngine ()
{
}
@property (nonatomic, assign) AFNetworkReachabilityStatus preReachabilityStatus;
@end

@implementation DataEngine

+ (DataEngine *)sharedInstance
{
    static DataEngine *dataEngineInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataEngineInstance = [[DataEngine alloc] init];
#ifdef TEST_SERVER
        [dataEngineInstance doSomeThingForTest];
#endif
    });
    return dataEngineInstance;
}


#pragma mark - <CLLocationManagerDelegate>
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init]) {
        _ioQueue = dispatch_queue_create("com.mandongkeji.dataEngineIO", DISPATCH_QUEUE_SERIAL);
        //init app info
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (!appName) {
            appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
        }
        self.appName = appName;
        self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        self.venderUniqueId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        _dispatchedOperations = [NSMutableArray arrayWithCapacity:5];
        
        _hasRetinaDisplay = [[UIDevice currentDevice] hasRetinaDisplay];
        
        //af network
        _afNormalManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://translation.googleapis.com/language/translate/v2"]];
        
        _afNormalManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self loadDefaultHeaders];
        
        _afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
        self.preReachabilityStatus = [AFNetworkReachabilityManager sharedManager].currentStatus;
        [_afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            } else if (status == AFNetworkReachabilityStatusNotReachable) {
            }
        }];
        [_afNetworkReachabilityManager startMonitoring];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    return self;
}

- (void)cancelRequests:(NSArray *)operations
{
    if (operations.count == 0) {
        return;
    }
    
    [operations makeObjectsPerformSelector:@selector(cancel)];
    [_dispatchedOperations removeObjectsInArray:operations];
}

+ (NSDictionary *)makeRequestParam:(NSString *)method
                         withParam:(NSDictionary *)param
{
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *paramJson = [JsonUtils StringWithJSONObject:param];
    paramJson = paramJson ? : @"";
    NSString *sig = [[[NSString stringWithFormat:@"%@%@%@", @"token", timestamp, paramJson] md5] lowercaseString];
    return [NSDictionary dictionaryWithObjectsAndKeys:method, @"method", timestamp, @"timestamp", paramJson, @"param", sig, @"sig", nil];
}

- (NSOperation *)translate:(NSString *)q
                withTarget:(NSString *)target
                withFormat:(NSString *)format
                withSource:(NSString *)source
                 withModel:(NSString *)model
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMsg))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (q.length == 0) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:q
             forKey:@"q"];
    [dict setObject:target.length ? target : @"zh-CN"
             forKey:@"target"];
    [dict setObject:format.length ? format : @"text"
             forKey:@"format"];
    if (source.length) {
        [dict setObject:source
                 forKey:@"source"];
    }
    [dict setObject:@"nmt"
             forKey:@"model"];
    [dict setObject:@"AIzaSyBvKcmcDJ_oK__hCvfBnnSd3I3QUy7h3nE"
             forKey:@"key"];
    AFHTTPRequestOperation *operation =
    [_afNormalManager POST:@""
                parameters:dict
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       if (success) {
                           success(operation, responseObject, nil);
                       }
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"%@", error.localizedDescription);
                       if (![error.domain isEqualToString:NSURLErrorDomain] || error.code != NSURLErrorCancelled) {
                           if (failure) {
                               failure(operation, error);
                           }
                       }
                   }];
    return operation;
}

- (NSOperation *)translateSimple:(NSString *)q
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMsg))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self translate:q
                withTarget:nil
                withFormat:nil
                withSource:nil
                 withModel:nil
                   success:success
                   failure:failure];
}

- (NSOperation *)loginByEmailAccount:(NSNumber *)source
                           withEmail:(NSString *)email
                        withPassword:(NSString *)password
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMsg))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (email.length == 0 || password.length == 0) {
        return nil;
    } else if (self.device_id.length == 0) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:email
             forKey:@"email"];
    [dict setObject:password
             forKey:@"password"];
    [dict setObject:self.device_id
             forKey:@"device_id"];
    NSDictionary *requestDict = [DataEngine makeRequestParam:@"account/sign_in"
                                                   withParam:dict];
    AFHTTPRequestOperation *operation =
    [_afNormalManager POST:@"ss"
                parameters:requestDict
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       NSString *errorMsg = @"haha";
                       if ([responseObject isKindOfClass:[NSDictionary class]]) {
                           errorMsg = @"ss";
                           if (errorMsg == nil) {
                           }
                       }
                       if (success) {
                           success(operation, responseObject, errorMsg);
                       }
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       NSLog(@"%@", error.localizedDescription);
                       if (![error.domain isEqualToString:NSURLErrorDomain] || error.code != NSURLErrorCancelled) {
                           if (failure) {
                               failure(operation, error);
                           }
                       }
                   }];
    return operation;
}

//notifications
- (void)deviceIdChanged:(NSNotification *)notification
{
    [self loadDefaultHeaders];
}

- (void)loginuserChanged:(NSNotification *)notification
{
    [self loadDefaultHeaders];
}

#pragma for init
//default headers
- (NSDictionary *)defaultHeaders
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:self.version ? : @""
                forKey:@"zzlVersion"];
    
    [headers setObject:[[UIDevice currentDevice] cusSystemName] ? : @""
                forKey:@"zzlType"];
    
    [headers setObject:[[UIDevice currentDevice] systemVersion]
                forKey:@"zzlSystemVersion"];
    
    [headers setObject:[[UIDevice currentDevice] model]
                forKey:@"zzlModel"];
    
    [headers setObject:self.device_id ? : @""
                forKey:@"zzDid"];
    
    [headers setObject:[[UIDevice currentDevice] venderString] ? : @""
                forKey:@"zzVendor"];
    
    [headers setObject:[[UIDevice currentDevice] resolutionString] ? : @""
                forKey:@"zzResolution"];
    
    [headers setObject:[[UIDevice currentDevice] currentNetType] ? : @""
                forKey:@"zzNetworking"];
    
    [headers setObject:[[UIDevice currentDevice] operatorCode] ? : @""
                forKey:@"zzOperators"];
    
    [headers setObject:[[UIDevice currentDevice] operatorName] ? : @""
                forKey:@"zzOperatorsName"];
    [headers setObject:[[UIDevice currentDevice] currentNetworkingType] ? : @""
                forKey:@"zzNetworkingType"];
    return headers;
}

- (void)loadDefaultHeaders
{
    [self.defaultHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [_afNormalManager.requestSerializer setValue:value forHTTPHeaderField:field];
    }];
}
@end
