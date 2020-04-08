//
//  XEWebViewProtocol.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XEWebView;

@protocol XEWebViewDelegate <NSObject>

@optional

- (void)webViewDidStartLoad:(id<XEWebView>)webView;
- (void)webViewDidFinishLoad:(id<XEWebView>)webView;
- (void)webView:(id<XEWebView>)webView didFailLoadWithError:(NSError *)error;
@optional

@end

@protocol XEWebView <NSObject>

/**
 监听 XENotice，收到通知做相应的操作
 */
@property (nonatomic, weak, nullable) id<XEWebViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/**
 webView 初始化请求
 */
@property (nonatomic, strong, readonly, nullable) NSURLRequest *originRequest;

/**
 webView 当前请求
 */
@property (nonatomic, strong, readonly, nullable) NSURLRequest *currentRequest;

/**
 能否返回上一页
 */
@property (nonatomic, assign, readonly) BOOL canGoBack;


/**
 加载请求

 @param request 请求
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 加载 HTML 字符串

 @param htmlString HTML 字符串
 @param baseUrl 请求链接
 */
- (void)loadHTMLString:(NSString *)htmlString baseUrl:(nullable NSURL *)baseUrl;

/**
 加载数据

 @param data 数据
 @param MIMEType MIMEType
 @param textEncodingName 文本编码名
 @param baseURL 请求链接
 */
- (void)loadData:(NSData *)data MIMEType:(nonnull NSString *)MIMEType textEncodingName:(nonnull NSString *)textEncodingName baseURL:(nonnull NSURL *)baseURL;

/**
 重新加载
 */
- (void)reload;


/**
 停止重新加载
 */
- (void)stopReloading;

/**
 返回上一页
 */
- (void)goBack;

/**
 能否返回上一页
 */
- (BOOL)canGoBack;

/**
 进入下一页
 */
- (void)goForward;


/**
 执行 JavaScript 字符串

 @param javaSriptString JavaScripte 字符串
 @return 结果
 */
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)javaSriptString;

/**
 执行 JavaScript 字符串，和完成回调

 @param javaScriptString JavaScript 字符串
 @param completionHandler 完成回调
 */
- (void)evaluateJaveScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(id _Nullable response, NSError *_Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
