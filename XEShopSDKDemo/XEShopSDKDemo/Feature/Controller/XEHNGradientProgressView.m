//
//  XEHNGradientProgressView.m
//  HNMarketProject
//
//  Created by chenwen on 2017/9/5.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "XEHNGradientProgressView.h"

static NSTimeInterval const kFastTimeInterval = 0.03;
static NSString const *kFastFinishTimeInterval = @"0.1" ;

@interface XEHNGradientProgressView ()

@property (nonatomic, strong) CALayer               *bgLayer;
@property (nonatomic, strong) CAGradientLayer       *gradientLayer;
@property (nonatomic, strong) NSTimer               *timer;

@end

@implementation XEHNGradientProgressView

#pragma mark -
#pragma mark - GET ---> view

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        //一般不用frame，因为不支持隐式动画
        _bgLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _bgLayer.anchorPoint = CGPointMake(0, 0);
        _bgLayer.backgroundColor = self.bgProgressColor.CGColor;
        _bgLayer.cornerRadius = self.frame.size.height / 2.;
    }
    return _bgLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = self.colorArr;
        _gradientLayer.colors = colorArr;
        _gradientLayer.cornerRadius = self.frame.size.height / 2.;
    }
    return _gradientLayer;
}

#pragma mark -
#pragma mark - SET ---> data

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateView];
}

- (void)setColorArr:(NSArray *)colorArr {
    if (colorArr.count >= 2) {
        _colorArr = colorArr;
        [self updateView];
    }else {
        NSLog(@">>>>>颜色数组个数小于2，显示默认颜色");
    }
}

#pragma mark -
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        [self simulateViewDidLoad];
        self.colorArr = @[(id)MQRGBColor(252, 244, 77).CGColor,(id)MQRGBColor(252, 93, 59).CGColor];
    }
    return self;
}

- (void)simulateViewDidLoad {
    [self addSubViewTree];
}

- (void)config {
//    self.bgProgressColor = MQRGBColor(230., 244., 245.);
    self.bgProgressColor = [UIColor whiteColor];
}

- (void)addSubViewTree {
    
    if (!_bgLayer.superlayer) {
        [self.layer addSublayer:self.bgLayer];
    }
    
    if (!_gradientLayer.superlayer) {
        _gradientLayer = nil;
        [self.layer addSublayer:self.gradientLayer];
    }
//    [self bgLayer];
//    [self gradientLayer];
}

- (void)updateView {
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
    self.gradientLayer.colors = self.colorArr;
}

//自动加载
- (void)startLoad {
    self.progress = 0.0;
    self.gradientLayer.bounds = CGRectMake(0, 0, 0, self.frame.size.height);
    [self addSubViewTree];
}

//自动加载完成
- (void)finished{
    [self removeMyLayer];
    self.progress = 0.0;
}


- (void)removeMyLayer{
    [self.bgLayer removeFromSuperlayer];
    [self.gradientLayer removeFromSuperlayer];
}

- (void)dealloc {
    //    NSLog(@"progressView dealloc");
}



@end
