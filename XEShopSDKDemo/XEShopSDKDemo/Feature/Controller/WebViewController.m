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
    
    // 初始化 webView
    self.webView = [[XEWebView alloc] initWithFrame:self.view.bounds webViewType:XEWebViewTypeWKWebView];
    self.webView.frame = self.view.bounds;
    self.webView.delegate = self;
    self.webView.noticeDelegate = self;
    [self.view addSubview:self.webView];
    
    // 初始化 navigationItem
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationItem.rightBarButtonItems = @[self.shareItem, self.reloadItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认分享按钮不可用
    
    // 加载请求
    [self loadAndLoadUrl:self.loadUrlString];
    
}



#pragma mark - XEWebViewNotice Delegate

- (void)webView:(id<XEWebView>)webView didReceiveNotice:(XENotice *)notice
{
    NSString *descString = [[NSString alloc] init];
    
    switch (notice.type) {
            case XENoticeTypeLogin:
        {
            // 登录通知
            descString = @"登录通知";
            NSLog(@"Notice: XENoticeTypeLogin");
            
            [self showLoginView];
        }
            break;
            case XENoticeTypeShare:
        {
            // 接收到分享请求的结果回调
            descString = @"分享";
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
            case XENoticeTypeReady:
        {
            // Web页面已准备好，分享接口可用
            descString = @"Web页面已准备好，分享接口可用";
            NSLog(@"Notice: XENoticeTypeReady");
            
            // 此时可以分享，但注意此事件并不作为是否可分享的标志事件
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        case XENoticeTypeTitleChange: { // 标题修改
            NSDictionary *param = notice.response;
            if ([param isKindOfClass:[NSDictionary class]]) {
                NSString *title = param[@"title"];
                self.navigationItem.title = title;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - XEWebViewDelegate Delegate (可选)

- (BOOL)webView:(id<XEWebView>)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}

- (void)webViewDidStartLoad:(id<XEWebView>)webView
{
    [self.progressView startLoad];
}

- (void)webViewDidFinishLoad:(id<XEWebView>)webView
{
    [self.progressView finished];
}

- (void)webView:(id<XEWebView>)webView didFailLoadWithError:(NSError *)error
{
    [self.progressView finished];
}

- (void)webViewWebContentProcessDidTerminate:(id<XEWebView>)webView
{
    
}

#pragma mark - Action

- (void)loginWithUserId:(NSString *)userId
{
    UserModel.shared.userId = userId;
    /**
     登录方法(在你使用时，应该换成自己服务器给的接口来获取cookie)
     */
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

#pragma mark - Private

/// 加载 URL
- (void)loadAndLoadUrl:(NSString *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
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


#pragma mark - Action

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
        _progressView = [[XEHNGradientProgressView alloc] initWithFrame:CGRectMake(0, [self kNavBarHeight], [UIScreen mainScreen].bounds.size.width, 1)];
        _progressView.bgProgressColor = [UIColor whiteColor];
        _progressView.colorArr = @[(id)[UIColor lightGrayColor].CGColor, (id)[UIColor lightGrayColor].CGColor];
        _progressView.progress = 0.1;
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
