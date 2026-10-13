[![Version](https://img.shields.io/cocoapods/v/XEShopSDK.svg?style=flat)](https://github.com/xiaoeteam/XiaoeAppSDK-iOS)
[![License](https://img.shields.io/cocoapods/l/PodDemo.svg?style=flat)](https://github.com/xiaoeteam/XiaoeAppSDK-iOS)
[![Platform](https://img.shields.io/cocoapods/p/PodDemo.svg?style=flat)](https://github.com/xiaoeteam/XiaoeAppSDK-iOS)


## 简述

通过小鹅通 APP 内嵌 SDK 可以在 App 内快速集成小鹅通提供的整个交易服务，享受完善的基础知识商品能力、营销玩法，更有小鹅通强劲的技术及服务作保障，实现低成本、高效率、强融合的移动商城方案，快速获得 App 流量的商业化变现。

## 环境要求

- iOS 15.0 及以上
- Xcode 27.0 及以上（SDK 使用 iOS 27 SDK 构建）

## 安装

### 通过 CocoaPods 安装

2.3.16 尚未发布到 CocoaPods 官方索引（trunk 当前最新版本为 2.3.15），请改用指定 Git tag 的方式引用：

1. 在你的 Podfile 文件中添加：

```ruby
pod 'XEShopSDK', :git => 'https://github.com/xiaoeteam/XiaoeAppSDK-iOS.git', :tag => '2.3.16'
```

2. 删除已存在的 Podfile.lock 文件，在命令行中执行 `pod install`

说明：

- 该方式会克隆整个仓库（含历史版本二进制，约 120MB），首次安装较慢
- 待 2.3.16 发布到 CocoaPods 后，可改回 `pod 'XEShopSDK','2.3.16'`
- 若需继续使用支持 iOS 8.0 及以上的旧版本，可继续使用官方索引：`pod 'XEShopSDK','2.3.15'`

### 手动导入

将 XEShopSDK 文件夹中的 `XEShopSDK.xcframework` 与 `XEShopSDK.bundle` 添加到你的 Xcode 工程中（SDK 为静态库，xcframework 无需 Embed）。

## 接入文档

https://github.com/xiaoeteam/XiaoeAppSDK-iOS/wiki

## 小鹅云

https://api-doc.xiaoe-tech.com/recall_scene/lnline_sdk/tech_doc.html

## 小鹅通官网

https://www.xiaoe-tech.com/

## License

[MIT](https://github.com/xiaoeteam/XiaoeAppSDK-iOS/blob/master/LICENSE)
