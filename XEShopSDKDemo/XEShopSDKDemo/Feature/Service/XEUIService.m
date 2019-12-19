//
//  XEUIService.m
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import "XEUIService.h"

@implementation XEUIService


+ (void)loginWithOpenUid:(NSString *)openUID
         completionBlock:(void(^)(NSDictionary *info))completionBlock
{
    
    NSDictionary *params = @{@"user_id" : openUID,
                            @"app_user_id": openUID,
                            @"sdk_app_id": @"883pzzGyzynE72G",
                            @"app_id": @"app38itOR341547",
                            @"secret_key": @"dfomGwT7JRWWnzY3okZ6yTkHtgNPTyhr"
    };
    
    NSURLRequest *request = [self requestWithURLString:@"https://app38itOR341547.sdk.xiaoe-tech.com/sdk_api/xe.account.login.test/1.0.0"
                                            Parameters:params];
    [self sendRequest:request completionBlock:completionBlock];
    NSLog(@"url = %@", request.URL);
    NSLog(@"params = %@", params);
    
}

+ (void)logoutWithOpenUid:(NSString *)openUID completionBlock:(void(^)(NSDictionary *info))completionBlock {
    NSDictionary* params = @{@"app_user_id" : openUID};
                             
    NSURLRequest *request = [self requestWithURLString:@"https://app38itor341547.sdk.xiaoe-tech.com/sdk_api/xe.account.logout.test/1.0.0"
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
    [request setValue: @"app_id=app38itOR341547; sdk_app_id=KfeSEfFWTwTzfkE" forHTTPHeaderField: @"Cookie"];
    return request.copy;
}

@end
