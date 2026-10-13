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

1. 在你的 Podfile 文件中添加：

```ruby
pod 'XEShopSDK','2.3.16'
```

2. 删除已存在的 Podfile.lock 文件，在命令行中执行 `pod install`

说明：

- 2.3.16 需要 iOS 15.0 及以上、Xcode 27.0 及以上
- 需要继续使用支持 iOS 8.0 及以上的旧版本时：`pod 'XEShopSDK','2.3.15'`
- 如需直接从指定 Git tag 安装（例如使用尚未发布到索引的版本）：
  `pod 'XEShopSDK', :git => 'https://github.com/xiaoeteam/XiaoeAppSDK-iOS.git', :tag => '2.3.16'`，
  该方式会克隆整个仓库（约 120MB），首次安装较慢

### 通过 Swift Package Manager 安装

在 Xcode 中选择 `File > Add Package Dependencies…`，输入本仓库地址：

```
https://github.com/xiaoeteam/XiaoeAppSDK-iOS.git
```

版本规则选择 `Up to Next Major`（或指定不低于 `2.3.17`），添加后勾选 `XEShopSDK` 库产品。

或在 `Package.swift` 中声明：

```swift
dependencies: [
    .package(url: "https://github.com/xiaoeteam/XiaoeAppSDK-iOS.git", from: "2.3.17")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "XEShopSDK", package: "XiaoeAppSDK-iOS")
        ]
    )
]
```

说明：

- 包内提供二进制 `XEShopSDK.xcframework`（静态库，含 `ios-arm64` 与 `ios-arm64_x86_64-simulator` 切片），最低 iOS 15.0
- 资源包 `XEShopSDK.bundle` 由 CocoaPods 方式会自动拷贝到 App 根目录；使用 SPM 时请把仓库中的 `XEShopSDK/XEShopSDK.bundle` 手动加入 App 的 `Copy Bundle Resources`，否则图片选择器的图标与本地化文案会缺失
- 首次拉取会克隆整个仓库（含历史版本二进制，约 120MB），耗时较长
- 接入方为 Objective-C 工程时，若用到静态库中的分类（Category），请在 `Other Linker Flags` 中保留 `-ObjC`

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
