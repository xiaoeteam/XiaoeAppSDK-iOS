//
//  XEConfig.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEConfig : NSObject

/**
 从小鹅通申请的店铺 id 
 */
@property (nonatomic, strong) NSString *appId;

/**
 从小鹅通申请的 SDK 店铺应用 id
 */
@property (nonatomic, strong) NSString *clientId;

/**
 APP 的 Scheme，设置后调用 HTML5 微信支付才能调转回您的 APP，例如：wechat
 */
@property (nonatomic, strong) NSString *scheme;

/**
 是否开启控制台日志输出，默认为 NO（仅 Debug 模式下有效）
 */
@property (nonatomic, assign) BOOL enableLog;

/**
 初始化配置
 
 @param clientId 从小鹅通申请的 sdk 应用 Id
 @param appId 从小鹅通申请的店铺 Id
 @return 配置实例
 */
- (instancetype)initWithClientId: (NSString *)clientId appId: (NSString *)appId;

@end


NS_ASSUME_NONNULL_END
