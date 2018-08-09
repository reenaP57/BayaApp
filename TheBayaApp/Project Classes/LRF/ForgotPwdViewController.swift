//
//  ForgotPwdViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ForgotPwdViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }
    
    func initialize() {
        self.title = "Forgot Password"
    }
}


//MARK:-
//MARK:- Action

extension ForgotPwdViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        if let resetPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ResetPwdViewController") as? ResetPwdViewController {
            self.navigationController?.pushViewController(resetPwdVC, animated: true)
        }
    }
    
}
