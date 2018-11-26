//
//  LoadPDFViewController.swift
//  TheBayaApp
//
//  Created by Mac-00016 on 19/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class LoadPDFViewController: ParentViewController {

    @IBOutlet weak var webView : UIWebView!
    var pdfUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.isOpaque = false;
        webView.backgroundColor = UIColor.clear
        MILoader.shared.showLoader(type: .circularRing, message: nil)
        webView.loadRequest(URLRequest(url: URL(string: pdfUrl)!))
    }
}

//MARK:-
//MARK:- UIWebview Delegate

extension LoadPDFViewController : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MILoader.shared.hideLoader()
    }
}
