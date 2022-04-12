//
//  WebViewController.m
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

#import "WebViewController.h"
#import "UserModel.h"
#import "XEUIService.h"
#import "XEHNGradientProgressView.h"
#import <XEShopSDK/XEShopSDK.h>

#define IPHONEX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

@interface WebViewController () <XEWebViewDelegate, XEWebViewNoticeDelegate>

// 网页
@property (nonatomic, strong) XEWebView *webView;
// 返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
// 关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;
// 刷新按钮
@property (nonatomic, strong) UIBarButtonItem *reloadItem;
// 分享按钮
@property (nonatomic, strong) UIBarButtonItem *shareItem;

@property (nonatomic, strong) XEHNGradientProgressView *progressView;

@end

@implementation WebViewController

- (void)dealloc
{
    _webView.delegate = nil;
    _webView.noticeDelegate = nil;
    _webView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     初始化小鹅内嵌课堂H5展示容器XEWebView （必须依附XEWebView容器）
     小鹅内嵌课堂H5展示区域通过控制XEWebView的Frame即可（APP端按需处理）
     （APP端接入时注意自身Y坐标兼容控制，避免被APP端本身导航条盖住网页顶部）
     注意：刘海屏 iPhone  需要配置与底部为 35 的安全距离
     */
    
    CGRect webFrame = self.view.bounds;
    
    // 注意：刘海屏 iPhone 需要配置与底部为 35 的安全距离
    CGFloat navHeight = IPHONEX ? 88 : 64;
    CGFloat bottom = IPHONEX ? 35 : 0;
    webFrame = CGRectMake(self.view.bounds.origin.x, navHeight, self.view.bounds.size.width, self.view.bounds.size.height - navHeight - bottom);
    
    self.webView = [[XEWebView alloc] initWithFrame:webFrame];
    self.webView.delegate = self;
    self.webView.noticeDelegate = self;
    [self.view addSubview:self.webView];
    
    // 初始化 navigationItem
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItems = @[self.shareItem, self.reloadItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认分享按钮不可用
    
    // 加载网页请求
    [self loadAndLoadUrl:self.loadUrlString];
    
}

#pragma mark - 网页请求  (SDK网页请求-必须接入)

/// 加载 URL
- (void)loadAndLoadUrl:(NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}


#pragma mark - XEWebViewNotice Delegate  (SDK代理回调-必须接入)

- (void)webView:(id<XEWebView>)webView didReceiveNotice:(XENotice *)notice
{
    switch (notice.type) {
        case XENoticeTypeReady:
        {
            // Web页面加载完成回调，APP端按需处理
            
            // 例如：此时可以分享，但注意此事件并不作为是否可分享的标志事件
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
            break;
        case XENoticeTypeLogin:
        {
            // SDK需要登录态通知回调 （APP端需要接入小鹅登录态API流程）
            // 小鹅登录态接入流程文档 https://admin.xiaoe-tech.com/helpCenter/problem?first_id=241&second_id=242&document_id=doc_5dca0f61d8b1c_jYm6p
            [self showLoginView];
        }
            break;
        case XENoticeTypeShare:
        {
            // 当前网页分享内容结果回调 （需先触发webview的share方法）
          
            NSDictionary *dict = (NSDictionary *)notice.response;
            NSString *content = [[NSString alloc] initWithFormat:@"%@", dict];
            [self showAlertTitle: @"分享信息" content: content];
            NSLog(@"Notice: XENoticeTypeShare = %@", dict);
            
            if ([notice.response isKindOfClass:[NSDictionary class]]) {
                
                NSString *str = dict[@"share_link"];
                NSLog(@"yes: %@", str);
            } else {
                NSLog(@"No");
            }
        }
            break;
        
        case XENoticeTypeTitleChange:
        {
            // 网页标题改变回调，APP端按需处理
            NSDictionary *param = notice.response;
            if ([param isKindOfClass:[NSDictionary class]]) {
                NSString *title = param[@"title"];
                self.navigationItem.title = title;
            }
        }
            break;
        case XENoticeTypeLoadProgressChange: {
            // 网页加载进度
            NSDictionary *param = notice.response;
            if ([param isKindOfClass:[NSDictionary class]] && [param[@"estimatedProgress"] isKindOfClass:[NSNumber class]]) {
                CGFloat estimatedProgress = [param[@"estimatedProgress"] floatValue];
                if (self.progressView.progress == 0) {
                    [self.progressView startLoad];
                }
                [self.progressView setProgress:estimatedProgress];
                if (estimatedProgress >= 1.0) {
                    [self.progressView finished];
                }
            }
        }
            break;
        case XENoticeTypeOutLinkUrl:
        {
            // 外部链接回调，APP端按需处理，规则为带参数 needoutlink=1 的链接,例：https://xiaoe-tech.com/?needoutlink=1
            NSDictionary *param = notice.response;
            NSLog(@"自定义链接: %@", param);
            [self showAlertTitle:param[@"out_link_url"] content: nil];
        }
            break;
        case XENoticeTypeAppPay:
        {
            //需要APP自行控制支付
            NSDictionary *param = notice.response;
            NSLog(@"待支付订单相关信息: %@", param);
            [self showAlertTitle:@"APP支付操作" content: @"请对接相关支付API接口完成后续整体支付流程"];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - XEWebViewDelegate Delegate (SDK代理回调-可选接入)

- (BOOL)webView:(id<XEWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}

- (void)webViewDidStartLoad:(id<XEWebView>)webView
{
}

- (void)webViewDidFinishLoad:(id<XEWebView>)webView
{
}

- (void)webView:(id<XEWebView>)webView didFailLoadWithError:(NSError *)error
{
}

- (void)webViewWebContentProcessDidTerminate:(id<XEWebView>)webView
{
    
}


#pragma mark - XEWebViewNotice Delegate  (SDK其它功能-可选接入)
/**
 点击刷新按钮
 */
- (void)onClickRefresh
{
    [self.webView reload];
}

/**
 点击分享按钮
 */
- (void)onClickShare
{
    [self.webView share];
}

/**
 点击返回按钮
 */
- (void)onClickBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self onClickClose];
    }
}


#pragma mark - 以下为APP端自身业务处理 ，按需处理


- (void)loginWithUserId:(NSString *)userId
{
    /**
    获取登录态 token（仅作测试使用）
    注意：该登录态获取接口仅作为小鹅内嵌课堂SDK的官方Demo测试使用，
       正式对接时，你应该请求贵方的APP服务端后台封装的正式登录态接口获取数据,
    
    @param openUID  APP登录用户唯一码
    @param completionBlock 回调
    */
    
    UserModel.shared.userId = userId;
    __weak typeof(self) weakSelf = self;
    [XEUIService loginWithOpenUid:[UserModel shared].userId completionBlock:^(NSDictionary *resultInfo) {
        if (resultInfo) {
            [XESDK.shared synchronizeCookieKey: resultInfo[@"data"][@"token_key"]
                                     cookieValue:resultInfo[@"data"][@"token_value"]];
        } else {
            [weakSelf showAlertTitle:@"登录失败" content: nil];
        }
    }];
}

/// 分享弹窗
- (void)showAlertTitle:(NSString *)title content:(NSString *)content
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle: @"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

/// 登录弹窗
- (void)showLoginView
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入账号";
        textField.tag = 0;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 登录
        NSString *userId;
        BOOL textFieldEmpty = NO;
        
        for (UITextField *textField in alertController.textFields) {
            if (textField.tag == 0) {
                userId = textField.text;
            }
            if (textField.text.length == 0) {
                textFieldEmpty = YES;
            }
        }
        
        if (!textFieldEmpty) {
            // 登录
            [weakSelf loginWithUserId:userId];
        }
    }];
    UIAlertAction *action_cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.webView cancelLogin];
    }];
    [alertController addAction:action];
    [alertController addAction:action_cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 点击关闭按钮
 */
- (void)onClickClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (UIBarButtonItem *)reloadItem
{
    if (!_reloadItem) {
        _reloadItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRefresh)];
    }
    return _reloadItem;
}

- (UIBarButtonItem *)shareItem
{
    if (!_shareItem) {
        _shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
    }
    return _shareItem;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"back"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        btn.frame = CGRectMake(0, 0, 40, 40);
        _closeItem.customView = btn;
    }
    return _closeItem;
}

- (XEHNGradientProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[XEHNGradientProgressView alloc] initWithFrame:CGRectMake(0, [self kNavBarHeight], [UIScreen mainScreen].bounds.size.width, 2)];
        _progressView.bgProgressColor = [UIColor whiteColor];
        _progressView.colorArr = @[(id)[UIColor redColor].CGColor, (id)[UIColor redColor].CGColor];
        _progressView.progress = 0.0;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}


/**
 导航栏高度
 
 @return 高度
 */
- (float)kNavBarHeight
{
    return [self isIPhoneX] ? 88 : 64;
}

- (BOOL)isIPhoneX
{
    float kScreenHeight = UIScreen.mainScreen.bounds.size.height;
    return kScreenHeight >= 812 && kScreenHeight < 1024;
}
@end
