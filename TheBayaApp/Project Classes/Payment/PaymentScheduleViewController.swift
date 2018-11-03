//
//  PaymentScheduleViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Razorpay

class PaymentScheduleViewController: ParentViewController {
   
    @IBOutlet fileprivate weak var vwNoOutstandingPayment : UIView!
    @IBOutlet fileprivate weak var vwPayment : UIView!
    @IBOutlet fileprivate weak var tblMilestone : UITableView!
    @IBOutlet fileprivate weak var btnCurrentDemand : UIButton!
    @IBOutlet fileprivate weak var btnNextPayment : UIButton!
    @IBOutlet fileprivate weak var lblMilestoneName : UILabel!
    @IBOutlet fileprivate weak var lblMilestonePercent : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneAmount : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneDate : UILabel!
    @IBOutlet fileprivate weak var lblDateTxt : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneInterest : UILabel!
    @IBOutlet fileprivate weak var lblTotalAmount : UILabel!
    @IBOutlet fileprivate weak var lblPaid : UILabel!
    @IBOutlet fileprivate weak var lblToBePaid : UILabel!
    @IBOutlet fileprivate weak var cnTblMilestoneHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var txtUTRNo : UITextField! {
        didSet{
            txtUTRNo.layer.borderWidth = 1
            txtUTRNo.layer.borderColor = CRGB(r: 185, g: 200, b: 207).cgColor
        }
    }
    var arrMilestone = [[String : AnyObject]]()
    var razorpay: Razorpay!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //...Redirect on home screen
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "Payment Schedule"
        
        //...RazorPay configuration
        razorpay = Razorpay.initWithKey("rzp_test_2CsIylqZj3kniC", andDelegate: self)
        
        vwNoOutstandingPayment.isHidden = true
        //vwPayment.hide(byHeight: true)
       // _ = vwNoOutstandingPayment.setConstraintConstant(0, edge: .bottom, ancestor: true)
        
        arrMilestone = [["name" : "MILESTONE 1", "date" : "10/12/2018", "percent" : "20", "amount" : "10,000"],
        ["name" : "MILESTONE 2", "date" : "10/12/2018", "percent" : "30", "amount" : "10,00,000"],
        ["name" : "MILESTONE 3", "date" : "10/12/2018", "percent" : "50", "amount" : "10,000,000"],
        ["name" : "MILESTONE 4", "date" : "10/12/2018", "percent" : "80", "amount" : "10,000"],
        ["name" : "MILESTON E 5", "date" : "10/12/2018", "percent" : "100", "amount" : "1000"],
        ["name" : "MILESTONE 6", "date" : "10/12/2018", "percent" : "100", "amount" : "1000"]] as [[String : AnyObject]]
        
        //...For set select by default button current demand
        self.btnPaymentModeClicked(sender: btnCurrentDemand)
        
        GCDMainThread.async {
            self.cnTblMilestoneHeight.constant = self.tblMilestone.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func btnBackClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


//MARK:-
//MARK:- Action

extension PaymentScheduleViewController {
 
    @IBAction func btnMakePaymentOnlineClicked (sender : UIButton) {
        
        let options: [String:Any] = [
            "amount" : "100", //mandatory in paise
            "description": "Test payment"]
        
        razorpay.open(options, displayController: self)
    }
    
    @IBAction func btnTransactionHistoryClicked (sender : UIButton) {
      
        if let transactionVC = CStoryboardPayment.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as? TransactionHistoryViewController {
            self.navigationController?.pushViewController(transactionVC, animated: true)
        }
    }
    
    @IBAction func btnSubmitUTRClicked (sender : UIButton) {
    
        if let paymentDoneVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentDoneViewController") as? PaymentDoneViewController {
            self.navigationController?.pushViewController(paymentDoneVC, animated: true)
        }
    }
    
    @IBAction func btnPaymentModeClicked (sender : UIButton) {
        
        btnCurrentDemand.isSelected = false
        btnNextPayment.isSelected = false
        btnCurrentDemand.backgroundColor = UIColor.clear
        btnNextPayment.backgroundColor = UIColor.clear
        btnNextPayment.layer.borderWidth = 1
        btnCurrentDemand.layer.borderWidth = 1
        btnNextPayment.layer.borderColor = ColorGray.cgColor
        btnCurrentDemand.layer.borderColor = ColorGray.cgColor
        
        if sender.isSelected {
            return
        }
        
        
        lblDateTxt.text = sender.tag == 0 ? "Due Date" : "Milestone Date"
        sender.isSelected = true
        sender.backgroundColor = ColorGreenSelected
        sender.layer.borderColor = ColorGreenSelected.cgColor
    }
}


//MARK:-
//MARK:- UITableView delegate and datasource

extension PaymentScheduleViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrMilestone.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return IS_iPad ? CScreenWidth * (50 / 768) : CScreenWidth * (45 / 375)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMilestoneTblCell") as? PaymentMilestoneTblCell {
            
            cell.lblName.text = arrMilestone[indexPath.row].valueForString(key: "name")
            cell.lblDate.text = arrMilestone[indexPath.row].valueForString(key: "date")
            cell.lblPercent.text = arrMilestone[indexPath.row].valueForString(key: "percent")
            cell.lblAmount.text = arrMilestone[indexPath.row].valueForString(key: "amount")
            
            cell.vwSeparater.isHidden = indexPath.row == self.arrMilestone.count-1
          
            return cell
        }
        return UITableViewCell()
    }
}


extension PaymentScheduleViewController : RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol {
    
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
