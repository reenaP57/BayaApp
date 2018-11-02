//
//  PayementViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PayementViewController: ParentViewController {

    @IBOutlet weak var txtPwd : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
}


//MARK:-
//MARK:- Action

extension PayementViewController {
    
    @IBAction fileprivate func btnEnterPasswordClicked (sender : UIButton) {
        
        if (txtPwd.text?.isBlank)! {
            self.view.addSubview(self.txtPwd.showValidationMessage(30.0, CBlankPassword))
        } else if !(self.txtPwd.text?.isValidPassword)! || (self.txtPwd.text?.count)! < 6 {
            self.view.addSubview(self.txtPwd.showValidationMessage(30.0, CInvalidPassword))
        } else {
            
            if let paymentScheduleVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentScheduleViewController") as? PaymentScheduleViewController {
                self.navigationController?.pushViewController(paymentScheduleVC, animated: true)
            }
        }
    }
}


//MARK:-
//MARK:- UITextFieldDelegate
extension PayementViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtPwd.hideValidationMessage(45.0)
        return true
    }
}
