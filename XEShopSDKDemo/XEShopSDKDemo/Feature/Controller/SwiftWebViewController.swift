//
//  SwiftWebViewController.swift
//  XEShopSDKDemo
//
//  Created by Pauley Liu on 2019/5/8.
//  Copyright © 2019 xiaoemac. All rights reserved.
//

import UIKit
import XEShopSDK


class SwiftWebViewController: UIViewController {
    var webView: XEWebView!
    // 店铺首页地址（更换自己的）
    var urlString = "http://app38itor341547.sdk.xiaoe-tech.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = XEWebView(frame: view.frame, webViewType: .uiWebView)
        webView.delegate = self
        webView.noticeDelegate = self
        view.addSubview(webView)
        
        if !urlString.isEmpty {
            let url = URL(string: self.urlString)!
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
}

extension SwiftWebViewController: XEWebViewDelegate {

    func webViewDidStartLoad(_ webView: XEWebViewProtocol) {
        print(#function)
    }

    func webViewDidFinishLoad(_ webView: XEWebViewProtocol) {
        print(#function)
    }
}

extension SwiftWebViewController: XEWebViewNoticeDelegate {
    func webView(_ webView: XEWebViewProtocol, didReceive notice: XENotice) {
        print(notice)
    }
}
