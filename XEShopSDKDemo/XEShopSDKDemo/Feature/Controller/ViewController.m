//
//  ViewController.m
//  XEShopSDKDemo
//
//  Created by xiaoemac on 2019/4/29.
//  Copyright © 2019年 xiaoemac. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "UserModel.h"
#import "XEUIService.h"
#import "XEShopSDKDemo-Swift.h"
#import <XEShopSDK/XEShopSDK.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *loginBarButton;
@property (nonatomic, strong) UIBarButtonItem *logoutBarButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewDataArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"演示 Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginBarButton = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(showLoginAlert)];
    self.navigationItem.leftBarButtonItem = self.loginBarButton;
    
    self.logoutBarButton = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStyleDone target:self action:@selector(showLogoutAlert)];
    
    [self setupTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateBarItem];
}

#pragma mark - Action

/**
 登录

 @param userId 用户 ID
 */
- (void)loginWithUserId:(NSString *)userId
{
    UserModel.shared.userId = userId;
    // 登录方法(在你使用时，应该换成自己服务器给的接口来获取cookie)
    __weak typeof(self) weakSelf = self;
    [XEUIService loginWithOpenUid:[UserModel shared].userId completionBlock:^(NSDictionary *resultInfo) {
        if (resultInfo) {
            
            [XESDK.shared synchronizeCookieKey: resultInfo[@"data"][@"token_key"]
                                     cookieValue:resultInfo[@"data"][@"token_value"]];
            
            [weakSelf updateBarItem];
        } else {
            [weakSelf showAlertTitle:@"登录失败" content: nil];
        }
    }];
}

/**
 退出登录
 */
- (void)logout
{
    __weak typeof(self) weakSelf = self;
    [XEUIService logoutWithOpenUid:[UserModel shared].userId completionBlock:^(NSDictionary *resultInfo) {
        if (resultInfo) {
            
            // SDK 退出登录 清除 Cookie 等信息
            [XESDK.shared logout];
            
            // 退出登录
            UserModel.shared.userId = nil;
            
            // 更新 BarItem
            [weakSelf updateBarItem];
            
        }
    }];
}

#pragma mark - Private

- (void)showAlertTitle:(NSString *)title content:(NSString *)content
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle: @"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

/**
 初始化 TableView
 */
- (void)setupTableView
{
    self.tableViewDataArray = @[@"演示 Demo", @"Swift 演示 Demo"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

/**
 获取当前用户 ID

 @return 用户 ID
 */
- (NSString *)currentId
{
    return [NSString stringWithFormat:@"ID:%@", UserModel.shared.userId];
}


/*
 更新 BarItem
 */
- (void)updateBarItem
{
    if  (UserModel.shared.userId.length > 0) {
        self.loginBarButton.title = [NSString stringWithFormat:@"ID:%@", UserModel.shared.userId];
        self.navigationItem.rightBarButtonItem = self.logoutBarButton;
    } else {
        self.loginBarButton.title = @"登录";
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 显示登录弹窗
 */
- (void)showLoginAlert
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
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action];
    [alertController addAction:action_cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 显示退出登录弹窗
 */
- (void)showLogoutAlert
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
          // 退出登录
          [weakSelf logout];
    }];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action];
    [alertController addAction:action_cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            WebViewController *vc = [[WebViewController alloc] init];
            // 店铺首页地址（更换自己的）
            vc.loadUrlString = @"https://app38itor341547.sdk.xiaoe-tech.com/";
            vc.title = self.tableViewDataArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            SwiftWebViewController *vc = [[SwiftWebViewController alloc] init];
            vc.title = self.tableViewDataArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        } 
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.tableViewDataArray[indexPath.row];
    return cell;
}

@end
