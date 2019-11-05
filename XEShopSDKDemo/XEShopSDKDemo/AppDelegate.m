//
//  AppDelegate.m
//  XEShopSDKDemo
//
//  Created by page on 2019/6/28.
//  Copyright © 2019 com.xiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <XEShopSDK/XEShopSDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    
    
    // 创建配置 clientId 从小鹅通申请的 sdk 应用 Id， appId 从小鹅通申请的店铺 Id
    XEConfig *config = [[XEConfig alloc] initWithClientId:@"KfeSEfFWTwTzfkE" appId: @"app38itOR341547"];
    
    // 关闭 SDK 日志输出
    config.enableLog = YES;
    
    // 配置 Scheme 以便微信支付完成后跳转返回
    config.scheme = @"XEShopSDKDemo"; // 你的scheme
    
    // 初始化 XESDK
    [XESDK.shared initializeSDKWithConfig:config];

    
    // 查看小鹅通 SDK 版本
    //    NSLog(@"小鹅通 SDK 版本：%@", XESDK.shared.version)
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


@end
