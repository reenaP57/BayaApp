//
//  CMSViewController.swift
//  TAP
//
//  Created by mac-00017 on 16/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

enum cmsTitle {
    case AboutUs
    case TermsCondition
    case PrivacyPolicy
}

class CMSViewController: ParentViewController {

    @IBOutlet weak var webContent : UIWebView!
    
    var cmsEnum = cmsTitle.AboutUs

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize(){
        
        switch cmsEnum {
        case .AboutUs :
            self.title = "About Us"
        case .TermsCondition :
            self.title = "Terms & Conditions"
        case .PrivacyPolicy :
            self.title = "Privacy Policy"
        }
        
        self.cms()
    }

    func cms()
    {
        let content = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." as String
        
        let font = UIFont.init(name: "Avenir-Medium", size: IS_iPad ? 20.0 : 13.0)
        self.webContent.loadHTMLString("<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); color: #333333\">\(content)</span>", baseURL: nil)

        
        self.webContent.isOpaque = false;
        self.webContent.backgroundColor = UIColor.clear

        
//        let myURL = URL(string: "https://www.apple.com")
//        let myRequest = URLRequest(url: myURL!)
//        self.webVw.loadRequest(myRequest)
    }

}

