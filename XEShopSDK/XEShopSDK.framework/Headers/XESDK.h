//
//  XESDK.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEWebView.h"

NS_ASSUME_NONNULL_BEGIN

@class XEConfig, XESDK;


// 小鹅通 APPSDK 通用信息管理以及 Cookie 和 Token 设置
@interface XESDK : NSObject

/**
 使用单例访问
 */
@property (class, readonly, strong) XESDK *shared;


/**
 SDK 配置
 */
@property (nonatomic, readonly) XEConfig *config;

/**
 SDK 版本号
 */
@property (nonatomic, strong, readonly) NSString *version;

/**
 初始化 SDK.
 使用 SDK 前必须先初始化 SDK.
 
 @param config 初始化配置。
 @see YZSDKConfig
 */
- (void)initializeSDKWithConfig:(XEConfig *)config;

/**
 同步授权信息
 
 建议认证策略：您向您的[APP 服务器]发送登陆请求，您的[APP 服务器]向[小鹅通服务器]发送 SSO 登陆请求。[小鹅通服务器]处理后，将相关登陆信息返回到您的[APP 服务器]，您的[APP 服务器]再将相关信息返回到[您的 APP]。

 @param cookieKey cookie_key
 @param cookieValue cookie_value
 */
- (void)synchronizeCookieKey:(nullable NSString*)cookieKey
                   cookieValue:(nullable NSString*)cookieValue;

/**
 APP 用户注销，清除 AccessToken、Cookie 等信息
 */
- (void)logout;


/**
 恢复SDK容器配置，对于出现页面跳转异常等情况可在每次进入容器时调用。
 1、修改全局Cookie策略，NSHTTPCookieAcceptPolicy
 */
- (void)resetBasicConfig;

/**
 由用户自定义传入host拦截黑名单，与SDK内部共同生效。
 可同步多次，同步即时生效。
 eg. [@"websiteA.com", @"websiteB.com"];
 */
- (void)synchronizeBlockDomains:(NSArray <NSString *>*)list;

@end

NS_ASSUME_NONNULL_END
