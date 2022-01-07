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
#import "XEShopSDKDemoMaro.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化window窗体
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    
    /* 以下为小鹅通内嵌店铺SDK初始化代码段 */
    /// clientId 从小鹅通申请的 Client ID
    /// appId 从小鹅通申请的店铺 Id
    /// scheme 当前接入APP的唯一url scheme值
    /// enableAppPayment 是否开启APP支付控制 ，默认不开启；开启需要监控webview通知回调XENoticeTypeAppPay进行自主处理支付流程
    /// enableLog 是否开启APP日志打印，默认不开启
    XEConfig *config = [[XEConfig alloc] initWithClientId:DefaultClientId
                                                    appId:DefaultAppId
                                                   scheme:@"app-unique-scheme"
                                         enableAppPayment:NO
                                                enableLog:NO];
    [XESDK.shared initializeSDKWithConfig:config];

    return YES;
}

@end
