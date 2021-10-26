//
//  XEUIService.m
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import "XEUIService.h"
#import "XEShopSDKDemoMaro.h"

@implementation XEUIService

/**
获取登录态 token（仅作测试使用）
注意：该登录态获取接口仅作为小鹅内嵌课堂SDK的官方Demo测试使用，
   正式对接时，你应该请求贵方的APP服务端后台封装的正式登录态接口获取数据,

@param openUID  APP登录用户唯一码
@param completionBlock 回调
*/
+ (void)loginWithOpenUid:(NSString *)openUID
         completionBlock:(void(^)(NSDictionary *info))completionBlock
{
    
    NSDictionary *params = @{@"user_id" : openUID,
                            @"app_user_id": openUID,
                            @"sdk_app_id": DefaultClientId,
                            @"app_id": DefaultAppId,
                            @"secret_key": DefaultSecretKey
    };
    
    NSURLRequest *request = [self requestWithURLString:[NSString stringWithFormat:@"https://%@.sdk.xiaoe-tech.com/sdk_api/xe.account.login.test/1.0.0",DefaultAppId]
                                            Parameters:params];
    [self sendRequest:request completionBlock:completionBlock];
    NSLog(@"url = %@", request.URL);
    NSLog(@"params = %@", params);
    
}


+ (void)sendRequest:(NSURLRequest *)request
    completionBlock:(void(^)(NSDictionary *info))completionBlock
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (!error && data) {
                                                  NSDictionary *resultInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
                                                  NSLog(@"resultInfo = %@", resultInfo);
                                                  if ([resultInfo[@"code"] intValue] == 0) {
                                                      if (completionBlock) {
                                                          completionBlock(resultInfo);
                                                      }
                                                  } else {
                                                      if (completionBlock) {
                                                          completionBlock(nil);
                                                      }
                                                  }
                                                  return;
                                              }
                                              if (completionBlock) {
                                                  completionBlock(nil);
                                              }
                                          });
                                      }];
    [dataTask resume];
}

+ (NSURLRequest *)requestWithURLString:(NSString *)urlString
                            Parameters:(NSDictionary *)parameters
{
    __block NSMutableString *queryString = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (queryString.length > 0) {
            [queryString appendFormat:@"&%@=%@",key,obj];
        } else {
            [queryString appendFormat:@"?%@=%@",key,obj];
        }
    }];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlString, queryString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue: [NSString stringWithFormat:@"app_id=%@; sdk_app_id=%@",DefaultAppId,DefaultClientId] forHTTPHeaderField: @"Cookie"];
    return request.copy;
}

@end
