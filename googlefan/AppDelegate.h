//
//  AppDelegate.h
//  googlefan
//
//  Created by Rena Wang on 2017/6/18.
//  Copyright © 2017年 Rena Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)theAppDelegate;
- (void)showActivityView:(NSString *)text
                  inView:(UIView *)view;
//hide prevoiusly showed hud
- (void)hideActivityView:(UIView *)view;
//first showe hud with succeed text and image for time seconds in view
- (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;
//first showe hud with failed text and image for time seconds in view
- (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;
- (void)showFinishToastActivityView:(NSString *)text
                           interval:(NSTimeInterval)time
                             inView:(UIView *)view;
- (void)showFailedToastActivityView:(NSString *)text
                           interval:(NSTimeInterval)time
                             inView:(UIView *)view;
- (void)showToastActivityView:(NSString *)text
                     interval:(NSTimeInterval)time
                       inView:(UIView *)view;

@end

