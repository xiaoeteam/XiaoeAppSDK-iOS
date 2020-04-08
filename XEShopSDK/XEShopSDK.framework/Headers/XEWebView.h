//
//  XEWebView.h
//  XEShopSDK
//
//  Created by xiaoemac on 2019/4/30.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import "XEWebViewBase.h"

NS_ASSUME_NONNULL_BEGIN


/**
 提供了 WebView 的所有能力，对小鹅通店铺的页面做了优化。
 */
@interface XEWebView : XEWebViewBase <XEWebView>


/**
 分享当前页，相关数据在 `webView:didReceiveNotive:` 中返回
 */
- (void)share;

/**
 取消登录
 通知 h5 用户执行取消登录操作，h5 在当前页做相应处理
 */
- (void)cancelLogin;

@end

NS_ASSUME_NONNULL_END
