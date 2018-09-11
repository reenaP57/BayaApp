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
        
        self.webContent.isOpaque = false;
        self.webContent.backgroundColor = UIColor.clear
        
        self.getCMSData()
    }
    
    func getCMSData() {
        
        APIRequest.shared().cms { (response, error) in
            
            if response != nil && error == nil {
                
                let data = response?.value(forKey: CJsonData) as? [[String : AnyObject]]
                var content = ""
                
                switch self.cmsEnum {
                case .AboutUs :
                    content = data![0]["cmsDesc"] as! String
                case .TermsCondition :
                    content = data![1]["cmsDesc"] as! String
                case .PrivacyPolicy :
                    content = data![2]["cmsDesc"] as! String
                }
                
                let font = UIFont.init(name: "Avenir-Medium", size: IS_iPad ? 20.0 : 13.0)
                self.webContent.loadHTMLString("<span style=\"font-family: \(font!.fontName); font-size: \(font!.pointSize); color: #333333\">\(content)</span>", baseURL: nil)
                
            }
        }
    }
    
}

