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
 获取登录态 token（仅作测试使用）
 注意：该登录态获取接口仅作为小鹅内嵌课堂SDK的官方Demo测试使用，
    正式对接时，你应该请求贵方的APP服务端后台封装的正式登录态接口获取数据,
 
 @param openUID  APP登录用户唯一码
 @param completionBlock 回调
 */
+ (void)loginWithOpenUid:(NSString *)openUID completionBlock:(void(^)(NSDictionary *info))completionBlock;



@end

NS_ASSUME_NONNULL_END
