//
//  VerificationViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VerificationViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtCode : UITextField!
    @IBOutlet fileprivate weak var lblNote : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
        self.title = "Verity Mobile Number"
    }

}


//MARK:-
//MARK:- Action

extension VerificationViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
    }
    
    @IBAction fileprivate func btnResendVerificationCodeClicked (sender : UIButton) {
        
    }
}
