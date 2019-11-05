//
//  XEWebViewBase.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEWebViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

/**
 XEWebView 支持的类型
 */
typedef NS_ENUM(NSUInteger, XEWebViewType) {
    XEWebViewTypeUIWebView,
    XEWebViewTypeWKWebView
};

@class XENotice;

@protocol XEWebViewNoticeDelegate <NSObject>

- (void)webView:(id<XEWebView>)webView didReceiveNotice:(XENotice *)notice;

@end

@interface XEWebViewBase : UIView <XEWebView, XEWebViewDelegate>

@property (nonatomic, weak) id<XEWebViewDelegate> delegate;
@property (nonatomic, weak) id<XEWebViewNoticeDelegate> noticeDelegate;

/**
 初始化并返回一个 XEWebView
 
 说明：
 - 使用 UIWebView 内核，可以得到首屏加速的能力，推荐使用
 - 使用 WKWebView 内核，可以得到 WKWebView 高性能，低内存的优点，但无法使用首屏加速，而且必须 iOS 8 以上版本才支持
 
 - iOS 8 以下版本统一返回 UIWebView 内核
 - iOS 8 及其以上版本根据 type 使用相应的内核

 @param webViewType WebView 的类型
 @return XEWebView 的实例
 */
- (instancetype)initWithFrame:(CGRect)frame webViewType:(XEWebViewType)webViewType;


@end

NS_ASSUME_NONNULL_END
