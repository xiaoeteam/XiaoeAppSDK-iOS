//
//  XEConfig.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 屏蔽APP虚拟支付的商品类型typedef NS_OPTIONS(NSInteger, WpfPageActionType)
typedef NS_OPTIONS(NSInteger, XEConfigDisableAppPaymentType) {
    XEConfigDisableAppPaymentType_None = 0,
    XEConfigDisableAppPaymentType_EntityGoods = 1 << 0,//实物商品
};

@interface XEConfig : NSObject

/**
 从小鹅通申请的店铺 id 
 */
@property (nonatomic, strong) NSString *appId;

/**
 从小鹅通申请的 client Id
 */
@property (nonatomic, strong) NSString *clientId;

/**
 APP 的 Scheme，设置后调用 HTML5 支付后才能调转回您的 APP，例如：wechat
 */
@property (nonatomic, strong) NSString *scheme;

/**
 是否开启控制台日志输出，默认为 NO（仅 Debug 模式下有效）
 */
@property (nonatomic, assign) BOOL enableLog;

/**
 是否开启APP支付控制
 */
@property (nonatomic, assign, readonly) BOOL enableAppPayment;

/**
 是否隐藏下单页优惠券入口
 */
@property (nonatomic, assign, readonly) BOOL hiddenOrderCoupon;


/**
 如果enableAppPayment为YES，可通过该属性独立控制屏蔽相关类型的商品走虚拟支付
 */
@property (nonatomic, assign, readonly) XEConfigDisableAppPaymentType disableAppPaymentTypes;

/**
 初始化配置
 
 @param clientId 从小鹅通申请的 sdk 应用 Id
 @param appId 从小鹅通申请的店铺 Id
 @return 配置实例
 */
- (instancetype)initWithClientId: (NSString *)clientId
                           appId: (NSString *)appId;

/**
 初始化配置
 
 @param clientId 从小鹅通申请的 Client ID
 @param appId 从小鹅通申请的店铺 Id
 @param scheme 当前接入APP的唯一url scheme值
 @return 配置实例
 */
- (instancetype)initWithClientId:(NSString *)clientId
                           appId:(NSString *)appId
                          scheme:(NSString *)scheme;

/// 初始化配置
/// @param clientId 从小鹅通申请的 Client ID
/// @param appId 从小鹅通申请的店铺 Id
/// @param scheme 当前接入APP的唯一url scheme值
/// @param hiddenCoupon 是否隐藏下单页优惠券入口
- (instancetype)initWithClientId:(NSString *)clientId
                           appId:(NSString *)appId
                          scheme:(NSString *)scheme
                    hiddenCoupon:(BOOL) hiddenCoupon;

/// 初始化配置
/// @param clientId 从小鹅通申请的 Client ID
/// @param appId 从小鹅通申请的店铺 Id
/// @param scheme 当前接入APP的唯一url scheme值
/// @param hiddenCoupon 是否隐藏下单页优惠券入口
/// @param enableAppPayment 是否开启APP支付控制 ，默认不开启
/// @param enableLog 是否开启APP日志打印，默认不开启
- (instancetype)initWithClientId:(NSString *)clientId
                           appId:(NSString *)appId
                          scheme:(NSString *)scheme
                    hiddenCoupon:(BOOL) hiddenCoupon
                enableAppPayment:(BOOL)enableAppPayment
                       enableLog:(BOOL)enableLog;


/// 初始化配置
/// @param clientId 从小鹅通申请的 Client ID
/// @param appId 从小鹅通申请的店铺 Id
/// @param scheme 当前接入APP的唯一url scheme值
/// @param hiddenCoupon 是否隐藏下单页优惠券入口
/// @param enableAppPayment 是否开启APP支付控制 ，默认不开启
/// @param disableAppPaymentTypes 如果enableAppPayment为YES，可通过该属性独立控制屏蔽相关类型的商品走虚拟支付
/// @param enableLog 是否开启APP日志打印，默认不开启
- (instancetype)initWithClientId:(NSString *)clientId
                           appId:(NSString *)appId
                          scheme:(NSString *)scheme
                    hiddenCoupon:(BOOL) hiddenCoupon
                enableAppPayment:(BOOL)enableAppPayment
          disableAppPaymentTypes:(XEConfigDisableAppPaymentType)disableAppPaymentTypes
                       enableLog:(BOOL)enableLog;

@end


NS_ASSUME_NONNULL_END
