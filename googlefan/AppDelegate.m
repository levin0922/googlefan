//
//  AppDelegate.m
//  googlefan
//
//  Created by Rena Wang on 2017/6/18.
//  Copyright © 2017年 Rena Wang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)theAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - global MBProgressHUD funs
- (void)showActivityView:(NSString *)text
                  inView:(UIView*)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
}

- (void)hideActivityView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)showFinishActivityView:(NSString*)text
                      interval:(NSTimeInterval)time
                        inView:(UIView*)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

- (void)showFailedActivityView:(NSString*)text
                      interval:(NSTimeInterval)time
                        inView:(UIView*)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activitycross.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

- (void)showFinishToastActivityView:(NSString *)text
                           interval:(NSTimeInterval)time
                             inView:(UIView *)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

- (void)showFailedToastActivityView:(NSString *)text
                           interval:(NSTimeInterval)time
                             inView:(UIView *)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activitycross.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}

- (void)showToastActivityView:(NSString *)text
                     interval:(NSTimeInterval)time
                       inView:(UIView *)view
{
    if (view == nil) {
        view = self.window;
    }
    BOOL has = [MBProgressHUD hideHUDForView:view animated:NO];
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:!has];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] init];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.userInteractionEnabled = NO;
    HUD.labelText = @"";
    HUD.detailsLabelText = text;
    [HUD hide:YES afterDelay:time];
}
@end
