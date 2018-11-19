//
//  OnlinePaymentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Razorpay

class OnlinePaymentViewController: ParentViewController {

    @IBOutlet weak var lblCurrentOutstanding : UILabel!
    @IBOutlet weak var lblPreviousOutstanding : UILabel!
    @IBOutlet weak var lblNextMilestoneOutstanding : UILabel!
    @IBOutlet weak var lblCurrentPreviousOutstanding : UILabel!
    @IBOutlet weak var txtAmountToPay : UITextField!
    @IBOutlet weak var vwContent : UIView!

    var razorpay: Razorpay!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    func initialize() {
        self.title = "Online Payment"
        
        //...RazorPay configuration
        razorpay = Razorpay.initWithKey("rzp_test_2CsIylqZj3kniC", andDelegate: self)
    }
}

//MARK:-
//MARK:- Action
extension OnlinePaymentViewController {
    
    @IBAction func selectAmountType (sender : UIButton) {
        
        switch sender.tag {
        case 0:
            txtAmountToPay.text = lblCurrentOutstanding.text
        case 1:
            txtAmountToPay.text = lblCurrentPreviousOutstanding.text
        case 2:
            txtAmountToPay.text = lblPreviousOutstanding.text
        case 3:
            txtAmountToPay.text = lblNextMilestoneOutstanding.text
        default:
            print("")
        }
        txtAmountToPay.hideValidationMessage(20.0)
    }
    
    @IBAction func btnTaxPayClicked (sender : UIButton) {
        
        if let paymentDoneVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentDoneViewController") as? PaymentDoneViewController {
            paymentDoneVC.isFromOnlinePayment = true
            self.navigationController?.pushViewController(paymentDoneVC, animated: true)
        }
    }
    
    @IBAction func btnAmountToPayClicked (sender : UIButton) {
        
        self.resignKeyboard()
        if (txtAmountToPay.text?.isBlank)! {
            self.vwContent.addSubview(self.txtAmountToPay.showValidationMessage(20.0, CBlankAmountToPay))
        } else {
            if let paymentDoneVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentDoneViewController") as? PaymentDoneViewController {
                paymentDoneVC.isFromOnlinePayment = true
                self.navigationController?.pushViewController(paymentDoneVC, animated: true)
            }
        }
   
        
        /* let options: [String:Any] = [
         "amount" : "1", //mandatory in paise
         "description": "Test payment"]
         
         razorpay.open(options, displayController: self) */
    }
    
}

//MARK:-
//MARK:- UITextFieldDelegate
extension OnlinePaymentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtAmountToPay.hideValidationMessage(20.0)
        return true
    }
}

//MARK:-
//MARK:- RazorPay Delegate
extension OnlinePaymentViewController : RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("Response : ",response as Any)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        
        print("Response : ",response as Any)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Description :\(str)", btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Payment id :\(payment_id)", btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
}
