//
//  XEHNGradientProgressView.h
//  HNMarketProject
//
//  Created by chenwen on 2017/9/5.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MQRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface XEHNGradientProgressView : UIView

/**
 *  进度条背景颜色  默认是 （230, 244, 245）
 */
@property (nonatomic, strong) UIColor *bgProgressColor;

/**
 *  进度条渐变颜色数组，颜色个数>=2
 *  默认是 @[(id)MQRGBColor(252, 244, 77).CGColor,(id)MQRGBColor(252, 93, 59).CGColor]
 */
@property (nonatomic, strong) NSArray *colorArr;

/**
 *  进度 默认是0.65
 */
@property (nonatomic, assign) CGFloat progress;

//默认自动加载
- (void)startLoaddefluat;

//自动加载
- (void)startLoad ;

//自动加载完成
- (void)finished ;
@end
