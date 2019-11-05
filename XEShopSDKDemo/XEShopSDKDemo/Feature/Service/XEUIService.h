//
//  XEUIService.h
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XEUIService : NSObject


/**
 获取登录态 token
 你应该在服务端处理登录信息的获取操作, 免得暴露隐私数据
 
 @param openUID 用户open id
 @param completionBlock 回调
 */
+ (void)loginWithOpenUid:(NSString *)openUID completionBlock:(void(^)(NSDictionary *info))completionBlock;

/**
 登出
 你应该在服务端处理登录信息的获取操作, 免得暴露隐私数据
 
 @param openUID 用户open id
 @param completionBlock 回调
 */
+ (void)logoutWithOpenUid:(NSString *)openUID completionBlock:(void(^)(NSDictionary *info))completionBlock;

@end

NS_ASSUME_NONNULL_END
