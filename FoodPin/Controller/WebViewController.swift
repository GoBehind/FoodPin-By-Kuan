//
//  WebViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/9/1.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var targetURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .always
        
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
