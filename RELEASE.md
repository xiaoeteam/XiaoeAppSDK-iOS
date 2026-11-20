# XEShopSDK 发布流程

面向维护者。当前已支持 **CocoaPods / Swift Package Manager / 手动导入** 三种分发方式，三者共用同一份 `XEShopSDK.xcframework`。

---

## 0. 前置条件

| 项 | 要求 |
| --- | --- |
| Xcode | 27.0 及以上（SDK 用 iOS 27 SDK 构建） |
| 最低支持版本 | iOS 15.0（`podspec`、`Package.swift`、Demo 工程三处保持一致） |
| CocoaPods | 已安装（本机在 `/opt/homebrew/bin/pod`，`pod --version` 应 ≥ 1.17） |
| GitHub 写权限 | SSH 密钥 `~/.ssh/id_rsa`（对应 GitHub 账号 `xiaoeteam`），已配别名 `github-xiaoeteam` |
| CocoaPods trunk | `pod trunk me` 有会话，且该账号是 `XEShopSDK` 的 owner（`pod trunk info XEShopSDK` 可见） |

> 本机 github.com:443（HTTPS）不通，只有 SSH(22) 可用。详见 `~/.ssh/GITHUB-SSH-GUIDE.md`。

---

## 1. 准备新产物

从构建同学获取 `XEShopSDK-<version>.xcframework.zip`，解压后先清理 macOS 垃圾文件：

```bash
unzip -q XEShopSDK-2.3.18.xcframework.zip
cd XEShopSDK.xcframework
find . -name '._*' -delete && find . -name '.DS_Store' -delete
```

核对四件事：

```bash
# 1) 版本号
plutil -p ios-arm64/XEShopSDK.framework/Info.plist | grep -E "CFBundleShortVersionString|MinimumOSVersion"
# 2) 切片齐全（应有 ios-arm64 与 ios-arm64_x86_64-simulator）
plutil -p Info.plist | grep LibraryIdentifier
# 3) 二进制架构
lipo -info ios-arm64/XEShopSDK.framework/XEShopSDK
# 4) 公开头文件是否变动
diff -rq ios-arm64/XEShopSDK.framework/Headers ../XEShopSDK/XEShopSDK.xcframework/ios-arm64/XEShopSDK.framework/Headers
```

---

## 2. 落库并更新配置

```bash
cd <repo>/XEShopSDK
rm -rf XEShopSDK.xcframework XEShopSDK.bundle
mv <解压目录>/XEShopSDK.xcframework .
# 顶层资源包供 CocoaPods 的 s.resources 使用，内容取自设备切片
cp -R XEShopSDK.xcframework/ios-arm64/XEShopSDK.framework/XEShopSDK.bundle .
```

同步修改：

- `XEShopSDK.podspec`：`s.version`、`s.platform` / `s.ios.deployment_target`
- `Package.swift`：`.iOS(.v15)`（与 podspec 保持一致）
- `XEShopSDKDemo/XEShopSDKDemo.xcodeproj/project.pbxproj`：`IPHONEOS_DEPLOYMENT_TARGET`（4 处）
- 需要时同步 `README.md` 中的版本号

**注意不要**再加 `EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64`——新切片已包含模拟器 arm64，加了反而会让 Apple Silicon 模拟器无法编译。

---

## 3. 本地验证（必做，全部通过才提交）

```bash
# a) 用 clang 直接验证两个切片都能编译链接
xcrun --sdk iphonesimulator clang -target arm64-apple-ios15.0-simulator -fobjc-arc \
  -F XEShopSDK/XEShopSDK.xcframework/ios-arm64_x86_64-simulator \
  -framework XEShopSDK -framework UIKit -framework Foundation main.m -o /tmp/out_sim
xcrun --sdk iphoneos clang -target arm64-apple-ios15.0 -fobjc-arc \
  -F XEShopSDK/XEShopSDK.xcframework/ios-arm64 \
  -framework XEShopSDK -framework UIKit -framework Foundation main.m -o /tmp/out_dev

# b) 校验 podspec（push 时也会自动执行）
pod lib lint XEShopSDK.podspec --allow-warnings

# c) Demo 集成验证（Demo 的 Podfile 用本地 podspec :path => '../'）
cd XEShopSDKDemo && rm -rf Pods Podfile.lock && pod install
xcodebuild -workspace XEShopSDKDemo.xcworkspace -scheme XEShopSDKDemo \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/dd -configuration Debug CODE_SIGNING_ALLOWED=NO build
```

SPM 侧建议再建一个临时消费者包验证（见第 7 节的验证命令）。

---

## 4. 提交与打 tag

```bash
git add -A && git commit -m "更新SDK：发布 2.3.18"
git tag -a 2.3.18 -m "XEShopSDK 2.3.18"
```

tag 规则（非常关键）：

1. **必须是纯 semver**：`2.3.18`、`2.3.18-beta.1` 都可以；`2.3.18.1`、`release-2.3.18` 会让 SPM 解析不到
2. **tag 内必须包含 `Package.swift`**：SPM 是按 tag 取包，该 tag 的提交里没有 `Package.swift` 就装不上
3. **一个版本号贯穿三处**：`podspec` 的 `s.version` = git tag = 二进制 `Info.plist` 的 `CFBundleShortVersionString`。`XESDK.shared.version` 读的是最后那个，三者不一致会导致接入方看到的版本号对不上

---

## 5. 推送到 GitHub

```bash
git remote -v     # 应为 git@github-xiaoeteam:xiaoeteam/XiaoeAppSDK-iOS.git
git push origin master
git push origin 2.3.18
```

推送被拒时的排查：

- `Permission ... denied to <账号>` → 用错密钥了。确认走的是 `id_rsa`（xiaoeteam 账号），
  可用 `ssh -F /dev/null -o IdentityAgent=none -o IdentitiesOnly=yes -i ~/.ssh/id_rsa -T git@github-xiaoeteam`
  验证身份
- HTTPS 地址超时 → 本机 443 不通，必须用 SSH 别名

---

## 6. 发布到 CocoaPods trunk

```bash
pod trunk me                        # 确认会话身份
pod trunk push XEShopSDK.podspec --allow-warnings
```

若校验阶段 clone 源码失败（本机 HTTPS 不通），用一次性的 git 地址改写走 SSH——**不修改任何全局配置**：

```bash
GIT_CONFIG_COUNT=1 \
GIT_CONFIG_KEY_0="url.git@github-xiaoeteam:xiaoeteam/.insteadOf" \
GIT_CONFIG_VALUE_0="https://github.com/xiaoeteam/" \
pod trunk push XEShopSDK.podspec --allow-warnings
```

注意事项：

- 版本一旦发布**不能删除**（只能 `pod trunk deprecate`），确认好版本号再执行
- 结尾出现 `Calling the GitHub commit API timed out` 是**非致命**的，先按第 7 节核对是否已发布，再决定是否重试
- `pod trunk push` 会先做本地 lint（含一次完整构建），比 Dry-run 慢，属正常

---

## 7. 发布后核对

```bash
# trunk 是否已有该版本
curl -s https://trunk.cocoapods.org/api/v1/pods/XEShopSDK | tail -c 300

# CDN 上的 spec 是否可下载（<a>/<b>/<c> 为 pod 名 md5 前三字符，XEShopSDK 固定为 f/3/a）
curl -sSL -o /dev/null -w '%{http_code}\n' \
  https://cdn.cocoapods.org/Specs/f/3/a/XEShopSDK/2.3.18/XEShopSDK.podspec.json

# README 徽章
curl -s https://img.shields.io/cocoapods/v/XEShopSDK.json
```

完整安装验证（CocoaPods）：

```bash
cd XEShopSDKDemo
# 临时把 Podfile 的 :path 行改成 pod 'XEShopSDK','2.3.18'，然后
rm -rf Pods Podfile.lock && pod install
xcodebuild -workspace XEShopSDKDemo.xcworkspace -scheme XEShopSDKDemo \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/dd Debug CODE_SIGNING_ALLOWED=NO build
# 验证完记得把 Podfile 改回 :path 形式
```

完整安装验证（SPM）：建一个临时消费者包，依赖本仓库并 `import XEShopSDK`，构建到 iOS 模拟器：

```swift
.package(url: "file:/// <本仓库绝对路径> ", exact: "2.3.18")
.product(name: "XEShopSDK", package: "XiaoeAppSDK-iOS")
```

---

## 8. 已知坑位清单

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| `Permission to xiaoeteam/XiaoeAppSDK-iOS.git denied to wpCXY` | `~/.ssh/config` 里 `Host github.com` 指定的密钥属于 wpCXY（个人号），命令行 `-i` 只是追加候选 | 用 `github-xiaoeteam` 别名，或 `ssh -F /dev/null -o IdentityAgent=none -o IdentitiesOnly=yes -i ~/.ssh/id_rsa` |
| trunk 报 `You need to register a session first` | 本机无 trunk 会话 | `pod trunk register <owner邮箱> '<名字>'` 后点邮件确认 |
| trunk push 报 `not an owner` / 无权推送 | 当前账号不是该 pod 的 owner | 用 owner 账号，或让 owner 执行 `pod trunk add-owner XEShopSDK <邮箱>` |
| trunk push 卡在 `git clone https://github.com/...` 失败 | 本机 443 不通 | 见第 6 节的一次性 `insteadOf` 改写 |
| `pod install` 报 `None of your spec sources contain a spec ... <新版本>` | 发布了但 CDN 分片索引未刷新（Cloudflare 边缘缓存 `max-age=600`） | 等 10 分钟左右；`all_pods_versions_f_3_a.txt?cb=时间戳` 可看源站是否已更新 |
| Demo 报 `range of supported deployment target versions is 15.0 to 27.0.x` | 工程里 `IPHONEOS_DEPLOYMENT_TARGET` 还是 8.0 | 改成 15.0（4 处） |
| SPM 解析不到新版本 | tag 里没有 `Package.swift`，或 tag 不是纯 semver | 从含 `Package.swift` 的提交打 tag |
| SPM 解析到与 pod 不同的版本号 | 存在额外的临时 tag（如只为 SPM 打的 2.3.17） | 只保留一个版本号；必要时删掉多余 tag |
| 接入方 ObjC 工程出现符号缺失 | SDK 为静态库，分类需 `-ObjC` | 接入方 `Other Linker Flags` 保留 `-ObjC` |
| SPM 接入后图片选择器资源缺失 | SPM 的 binaryTarget 不携带资源，`XEShopSDK.bundle` 不会自动落到 App 根目录 | 接入方手动把 `XEShopSDK.bundle` 加入 `Copy Bundle Resources` |
| `pod lib lint` / SPM 命令报 `Operation not permitted` | 工具要写 `~/Library/Developer/Xcode/DerivedData`、`~/Library/Caches/org.swift.swiftpm` 等目录 | 放开文件权限，或把缓存/DerivedData 重定向到可写目录 |

---

## 9. 出问题时的补救

| 情况 | 处理 |
| --- | --- |
| 二进制有严重问题 | trunk 版本不可删，只能修好后发**新版本号**，并对旧版本执行 `pod trunk deprecate XEShopSDK 2.3.18 --message="..."` |
| tag 打错（漏了 `Package.swift`、版本号不对） | 刚推送且无人依赖时，可删除远端 tag 重打：`git push origin :refs/tags/<tag>` 后重新 `git tag -a` 并推送；已有依赖则发新版本 |
| podspec 传错（路径/最低版本写错） | 立即发新版本修正；旧版本可 deprecate |

---

## 10. 版本号一致性自检（发布前最后一遍）

```bash
echo "podspec : $(grep -oE "s.version += '[0-9.]+'" XEShopSDK.podspec)"
echo "设备切片 : $(plutil -extract CFBundleShortVersionString raw XEShopSDK/XEShopSDK.xcframework/ios-arm64/XEShopSDK.framework/Info.plist)"
echo "模拟器切片: $(plutil -extract CFBundleShortVersionString raw XEShopSDK/XEShopSDK.xcframework/ios-arm64_x86_64-simulator/XEShopSDK.framework/Info.plist)"
echo "latest tag: $(git describe --tags --abbrev=0)"
grep -n "iOS(" Package.swift
grep -c "IPHONEOS_DEPLOYMENT_TARGET = 15.0" XEShopSDKDemo/XEShopSDKDemo.xcodeproj/project.pbxproj
```
