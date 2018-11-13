//
//  PaymentDoneViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PaymentDoneViewController: ParentViewController {

    var isFromOnlinePayment : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment Done Successfully"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOnlinePayment {
            //...If user come from rate screen that time it will be redirect on maintenance list screen
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
        }
    }
}

//MARK:-
//MARK:- Action

extension PaymentDoneViewController {
    
    @IBAction func btnViewReceiptClicked (sender : UIButton) {
        
    }
    
    @objc func btnBackClicked() {
        
        for vwController in (self.navigationController?.viewControllers)! {
            
            if vwController.isKind(of: PaymentScheduleViewController.classForCoder()){
                
                if let paymentScheduleVC = vwController as? PaymentScheduleViewController {
                    self.navigationController?.popToViewController(paymentScheduleVC, animated: true)
                }
                break
            }
        }
    }
}
