//
//  WebViewController.h
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 演示网页控制器
@interface WebViewController : UIViewController

/**
 首次加载的链接
 */
@property (nonatomic, copy) NSString *loadUrlString;

@end

NS_ASSUME_NONNULL_END
