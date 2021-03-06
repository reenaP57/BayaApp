//
//  PaymentScheduleViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PaymentScheduleViewController: ParentViewController {
   
    @IBOutlet fileprivate weak var scrollVw : UIScrollView!
    @IBOutlet fileprivate weak var vwNoOutstandingPayment : UIView!
    @IBOutlet fileprivate weak var vwPayment : UIView!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var vwMileStoneDetail : UIView!
    @IBOutlet fileprivate weak var tblMilestone : UITableView!
    @IBOutlet fileprivate weak var btnCurrentDemand : UIButton!
    @IBOutlet fileprivate weak var btnNextPayment : UIButton!
    @IBOutlet fileprivate weak var btnMakeOnlinePayment : UIButton!
    @IBOutlet fileprivate weak var btnUTRSubmit : UIButton!
    @IBOutlet fileprivate weak var lblNoDemandMsg : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneName : UILabel!
    @IBOutlet fileprivate weak var lblMilestonePercent : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneAmount : UILabel!
    @IBOutlet fileprivate weak var lblMilestoneDate : UILabel!
    @IBOutlet fileprivate weak var lblDateTxt : UILabel!
    @IBOutlet fileprivate weak var lblTotalAmount : UILabel!
    @IBOutlet fileprivate weak var lblPaid : UILabel!
    @IBOutlet fileprivate weak var lblToBePaid : UILabel!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
    @IBOutlet fileprivate weak var cnTblMilestoneHeight : NSLayoutConstraint!
    @IBOutlet fileprivate weak var txtUTRNo : UITextField! {
        didSet{
            txtUTRNo.layer.borderWidth = 1
            txtUTRNo.layer.borderColor = CRGB(r: 185, g: 200, b: 207).cgColor
        }
    }
    var arrMilestone = [[String : AnyObject]]()
    var currentDemandDetail = [String : AnyObject]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        
        //...Redirect on home screen
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "Payment Schedule"
        
        GCDMainThread.async {
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.refreshControl.tintColor = ColorGreenSelected
            self.scrollVw.refreshControl = self.refreshControl
        }
        
        vwNoOutstandingPayment.isHidden = true
        self.loadMilestoneList(showLoader: true)

    }
    
    fileprivate func showNoOutstandingView(message : String) {
        lblNoDemandMsg.text = message
        vwPayment.hide(byHeight: true)
        vwNoOutstandingPayment.isHidden = false
        _ = vwNoOutstandingPayment.setConstraintConstant(0, edge: .bottom, ancestor: true)
    }
    
    fileprivate func hideNoOutstandingView() {
        vwPayment.hide(byHeight: false)
        vwNoOutstandingPayment.isHidden = true
        _ = vwNoOutstandingPayment.setConstraintConstant(87, edge: .bottom, ancestor: true)
    }
    
    fileprivate func disablePaymentOption(isEnable : Bool) {
        
        if isEnable {
            //...Current Demand available
            
            btnUTRSubmit.isEnabled = true
            btnUTRSubmit.backgroundColor = ColorGreenSelected
            btnUTRSubmit.setTitleColor(ColorWhite, for: .normal)
            btnMakeOnlinePayment.isEnabled = true
            btnMakeOnlinePayment.setTitleColor(ColorLightBlack, for: .normal)
            txtUTRNo.isUserInteractionEnabled = true
        } else {
            //...Current Demand not available

            btnUTRSubmit.isEnabled = false
            btnUTRSubmit.backgroundColor = UIColor.lightGray
            btnUTRSubmit.setTitleColor(ColorWhite, for: .normal)
            btnMakeOnlinePayment.isEnabled = false
            btnMakeOnlinePayment.setTitleColor(ColorGray, for: .normal)
            txtUTRNo.isUserInteractionEnabled = false
        }

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
            
            cell.lblName.text = arrMilestone[indexPath.row].valueForString(key: CName)
            cell.lblDate.text = DateFormatter.dateStringFrom(timestamp: arrMilestone[indexPath.row].valueForDouble(key: CDueDate), withFormate: "dd/MM/yyyy")
            cell.lblPercent.text = arrMilestone[indexPath.row].valueForString(key: CPercent)
            cell.lblAmount.text = arrMilestone[indexPath.row].valueForString(key: CMilestoneAmount)
            
            cell.vwSeparater.isHidden = indexPath.row == self.arrMilestone.count-1
          
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:-
//MARK:- API

extension PaymentScheduleViewController {
    
    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        self.loadMilestoneList(showLoader: false)
    }
    
    func loadMilestoneList(showLoader : Bool) {
        
        _ = APIRequest.shared().getMilestoneList(showLoader:showLoader) { (response, error) in
            
            self.refreshControl.endRefreshing()
            if response != nil {
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    self.arrMilestone.removeAll()
                    
                    var paidAmount = 0
                    var totalAmount = 0
                    
                    if arrData.count > 0 {
                        self.arrMilestone = arrData
                        
                        //...Calculate Total Amount
                        let arrTotal = self.arrMilestone.mapValue(forKey: CMilestoneAmount) as? [Int]
                        totalAmount = arrTotal?.reduce(0, +) ?? 0
                        
                        //...Calculate Paid Amount
                        let arrPaidAmount = self.arrMilestone.filter({ $0.valueForInt(key: CPaymentStatus) == CPaymentPaid})
                        if arrPaidAmount.count > 0 {
                            let arrTotal = arrPaidAmount.mapValue(forKey: CMilestoneAmount) as? [Int]
                            paidAmount = arrTotal?.reduce(0, +) ?? 0
                        }
                    }
        
                    //...Set amount detail here
                    self.lblTotalAmount.text = self.setCurrencyFormat(amount: Float(totalAmount))
                    self.lblPaid.text = self.setCurrencyFormat(amount: Float(paidAmount))
                    //"\(paidAmount)"
                    self.lblToBePaid.text = self.setCurrencyFormat(amount: Float(totalAmount - paidAmount))
                    //"\(totalAmount - paidAmount)"
                }
                
                self.tblMilestone.reloadData()
                GCDMainThread.async {
                    self.cnTblMilestoneHeight.constant = self.tblMilestone.contentSize.height
                    self.view.layoutIfNeeded()
                }
                
                //...For set select by default button current demand
                self.btnPaymentModeClicked(sender: self.btnCurrentDemand)
                
                self.lblNoData.isHidden = self.arrMilestone.count != 0
                self.scrollVw.isHidden = self.arrMilestone.count == 0
            }
        }
    }
    
    func savePaymentUTR() {
        //...Offline Payment By UTR Number
        
        APIRequest.shared().savePaymentUTR(milestoneID: currentDemandDetail.valueForInt(key: "id"), utr: txtUTRNo.text!) { (response, error) in
            if response != nil {
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    self.showAlertView(metaData.valueForString(key: CJsonMessage), completion: nil)
                }
                self.txtUTRNo.text = ""
                self.loadMilestoneList(showLoader: false)
            }
        }
    }
}

//MARK:-
//MARK:- Action

extension PaymentScheduleViewController {
    
    @IBAction func btnMakePaymentOnlineClicked (sender : UIButton) {

        if let onlinePaymentVC = CStoryboardPayment.instantiateViewController(withIdentifier: "OnlinePaymentViewController") as? OnlinePaymentViewController {
            onlinePaymentVC.demandDetail = currentDemandDetail
            self.navigationController?.pushViewController(onlinePaymentVC, animated: true)
        }
    }
    
    @IBAction func btnTransactionHistoryClicked (sender : UIButton) {
        
        if let transactionVC = CStoryboardPayment.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as? TransactionHistoryViewController {
            self.navigationController?.pushViewController(transactionVC, animated: true)
        }
    }
    
    @IBAction func btnSubmitUTRClicked (sender : UIButton) {
        
        if (txtUTRNo.text?.isBlank)! {
            self.showAlertView(CBlankUTR, completion: nil)
            return
        }
        
        self.savePaymentUTR()
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
        
        sender.isSelected = true
        sender.backgroundColor = ColorGreenSelected
        sender.layer.borderColor = ColorGreenSelected.cgColor
        
        //...Get payment status from milestone list
        let arrData = arrMilestone.mapValue(forKey: CPaymentStatus) as? [Int]
        
        if sender.tag == 0 {    //...Current demand
           
            lblDateTxt.text = "Due Date"
            
            //...Get first paymentstatus = 2 milestone from milestone list for current demand
            if (arrData?.count)! > 0 {
                if let index = arrData!.index(where: {$0 == CPaymentDemand}) {
                    currentDemandDetail = arrMilestone[index]
                    self.hideNoOutstandingView()
                    self.disablePaymentOption(isEnable: true)
                } else {
                    self.disablePaymentOption(isEnable: false)

                    //...Check if any milestone in process mode
                    if (arrData?.contains(CPaymentProcess))! {
                        self.showNoOutstandingView(message: CPaymentInProcessing)
                    } else {
                        self.showNoOutstandingView(message: CNoOutstandingPayment)
                    }
                    
                    return
                }
            } else {
                self.disablePaymentOption(isEnable: false)
                self.showNoOutstandingView(message: CNoOutstandingPayment)
                return
            }
            
        } else {    //...Next Payment
            
            lblDateTxt.text = "Milestone Date"
            
            //...Get first paymentstatus = 1 milestone from milestone list for Next Payment
            if (arrData?.count)! > 0 {
                if let index = arrData!.index(where: {$0 == CPaymentUnPaid}) {
                    currentDemandDetail = arrMilestone[index]
                    self.hideNoOutstandingView()
                } else {
                    self.showNoOutstandingView(message: CNoNextPayment)
                    return
                }
            } else {
                self.showNoOutstandingView(message: CNoNextPayment)
                return
            }
        }
        
        self.lblMilestoneName.text = currentDemandDetail.valueForString(key: CName)
        self.lblMilestoneDate.text = DateFormatter.dateStringFrom(timestamp: currentDemandDetail.valueForDouble(key: CDueDate), withFormate: "dd/MM/yyyy")
        self.lblMilestonePercent.text = currentDemandDetail.valueForString(key: CPercent)
        self.lblMilestoneAmount.text = self.setCurrencyFormat(amount: Float(currentDemandDetail.valueForString(key: CMilestoneAmount))!)
    }
    
    @objc func btnBackClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

