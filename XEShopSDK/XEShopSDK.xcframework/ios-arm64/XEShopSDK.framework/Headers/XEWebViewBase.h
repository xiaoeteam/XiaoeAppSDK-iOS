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

@class XENotice;

@protocol XEWebViewNoticeDelegate <NSObject>

- (void)webView:(id<XEWebView>)webView didReceiveNotice:(XENotice *)notice;

@end

@interface XEWebViewBase : UIView <XEWebView, XEWebViewDelegate>

@property (nonatomic, weak) id<XEWebViewDelegate> delegate;
@property (nonatomic, weak) id<XEWebViewNoticeDelegate> noticeDelegate;

/**
 初始化并返回一个 XEWebView
 @return XEWebView 的实例
 */
- (instancetype)initWithFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
