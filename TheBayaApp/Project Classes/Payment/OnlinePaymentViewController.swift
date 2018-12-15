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
    @IBOutlet weak var lblGST : UILabel!
    @IBOutlet weak var lblGSTPercentage : UILabel!
    @IBOutlet weak var lblAmountToBePaid : UILabel!
    @IBOutlet weak var txtAmountToPay : UITextField!

    var demandDetail = [String : AnyObject]()
    var amountPaymentID = ""
    var gstPaymentID = ""
    var razorpay: Razorpay!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        self.title = "Online Payment"
        
        //...Set payment detail
        lblCurrentOutstanding.text = self.setCurrencyFormat(amount: Float(demandDetail.valueForString(key: CMilestoneAmount))!)
        lblAmountToBePaid.text = self.setCurrencyFormat(amount: Float(demandDetail.valueForString(key: CMilestoneAmount))!)
        lblGST.text = self.setCurrencyFormat(amount: Float(demandDetail.valueForInt(key: CMilestoneAmount)! * demandDetail.valueForInt(key: CGST)!/100))
        lblGSTPercentage.text = "GST(\(demandDetail.valueForInt(key: CGST) ?? 0)%):"
      
        //...RazorPay configuration
        razorpay = Razorpay.initWithKey(CRazorPayKey, andDelegate: self)
    }
    
}

//MARK:-
//MARK:- Action
extension OnlinePaymentViewController {
    
    @IBAction func selectAmountType (sender : UIButton) {
        txtAmountToPay.text = lblCurrentOutstanding.text
        txtAmountToPay.hideValidationMessage(20.0)

        if let payAmount = Float(demandDetail.valueForString(key: CMilestoneAmount)) {
            let gstAmount = demandDetail.valueForFloat(key: CGST)!/100
            lblGST.text = self.setCurrencyFormat(amount: payAmount * gstAmount)
            lblAmountToBePaid.text = self.setCurrencyFormat(amount: payAmount + (payAmount * gstAmount))
        }
        
//        let payAmount = Int(lblCurrentOutstanding.text ?? "")
//        lblGST.text = "\(payAmount! * (demandDetail.valueForInt(key: CGST)!)/100)"
//        lblAmountToBePaid.text = "\(Int(txtAmountToPay.text ?? "")! + payAmount! * (demandDetail.valueForInt(key: CGST)!)/100)"
    }
    
    @IBAction func btnAmountToPayClicked (sender : UIButton) {

        self.resignKeyboard()
        
        var amount : Int = 0
        if let payAmount = Int(txtAmountToPay.text?.replacingOccurrences(of: ",", with: "") ?? "") {
             amount = payAmount
        }
        
        if (txtAmountToPay.text?.isBlank)! {
            self.view.addSubview(self.txtAmountToPay.showValidationMessage(20.0, CBlankAmountToPay))
        } else if (amount > demandDetail.valueForInt(key: CMilestoneAmount)!){
            self.view.addSubview(self.txtAmountToPay.showValidationMessage(20.0, CAmountNotBeMoreThanCurrentDemand))
        } else if (amount < 50000){
            self.view.addSubview(self.txtAmountToPay.showValidationMessage(20.0, CAmountMinimumPayable))
        } else {
            //...Make payment for amount here
            let options: [String:Any] = [
                "amount" : "\(amount * 100)" ,//mandatory in paise
                "description": demandDetail.valueForString(key: CName),
                "name" : "\(appDelegate.loginUser?.firstName ?? "") \(appDelegate.loginUser?.lastName ?? "")"]
            
            self.razorpay.open(options, displayController: self)
        }
    }
    
}

//MARK:-
//MARK:- UITextFieldDelegate
extension OnlinePaymentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtAmountToPay.hideValidationMessage(20.0)
        return true
    }
    
    @IBAction func textFieldDidChange(_ textField : UITextField){
        if let payAmount = Float(txtAmountToPay.text?.replacingOccurrences(of: ",", with: "") ?? "") {
            let gstAmount = demandDetail.valueForFloat(key: CGST)!/100
            lblGST.text = self.setCurrencyFormat(amount: payAmount * gstAmount)
            lblAmountToBePaid.text = self.setCurrencyFormat(amount: payAmount + (payAmount * gstAmount))
        }
        
        if textField.text == "" {
            lblGST.text = "0"
            lblAmountToBePaid.text =  self.setCurrencyFormat(amount: Float(demandDetail.valueForString(key: CMilestoneAmount))!)
        }
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
        if amountPaymentID != "" {
            amountPaymentID = ""
            gstPaymentID = ""
        }
        self.showAlertView(str, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        
        if amountPaymentID == "" {
            //...Amount payment success
            amountPaymentID = payment_id
            
            //(amount * gst/100)*100
            let amount = (Float(txtAmountToPay.text!.replacingOccurrences(of: ",", with: ""))! * demandDetail.valueForFloat(key: CGST)!/100)*100

            //...Make payment for GST Tax
            let options: [String:Any] = [
                "amount" : "\(Int(amount))" ,//mandatory in paise
                "description": "Tax for(\(demandDetail.valueForString(key: CName)))",
                "name" : "\(appDelegate.loginUser?.firstName ?? "") \(appDelegate.loginUser?.lastName ?? "")"]
            
            self.razorpay.open(options, displayController: self)
        } else {
            //...GST payment success
            gstPaymentID = payment_id
            
            if let paymentDoneVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentDoneViewController") as? PaymentDoneViewController {
                paymentDoneVC.isFromOnlinePayment = true
                paymentDoneVC.paymentDetail = ["milestoneID" : demandDetail.valueForInt(key: "id")!, "amountPaymentID" : amountPaymentID, "gstPaymentID" : gstPaymentID] as [String : AnyObject]
                self.navigationController?.pushViewController(paymentDoneVC, animated: true)
            }
        }
    }
}

