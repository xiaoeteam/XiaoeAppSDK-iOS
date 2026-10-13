// swift-tools-version:5.7
//
//  Package.swift
//  XEShopSDK
//
//  小鹅通 App 内嵌课堂 SDK —— Swift Package Manager 支持
//  二进制产物位于 XEShopSDK/XEShopSDK.xcframework（静态库，含 ios-arm64 与 ios-arm64_x86_64-simulator 切片）
//

import PackageDescription

let package = Package(
    name: "XEShopSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "XEShopSDK",
            targets: ["XEShopSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "XEShopSDK",
            path: "XEShopSDK/XEShopSDK.xcframework"
        )
    ]
)
