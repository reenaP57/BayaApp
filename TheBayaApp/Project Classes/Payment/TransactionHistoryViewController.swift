//
//  TransactionHistoryViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: ParentViewController {

    @IBOutlet weak var tblTransaction : UITableView!
    var arrTransaction = [[String : AnyObject]]()
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var currentPage : Int = 1
    var totalPayableAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        self.title = "Transaction History"
        
        refreshControl.tintColor = ColorGreenSelected
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblTransaction.pullToRefreshControl = refreshControl
        
        self.loadMilestoneList(showLoader: true)
        tblTransaction.estimatedRowHeight = 160
        tblTransaction.rowHeight = UITableViewAutomaticDimension
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension TransactionHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTblCell") as? TransactionTblCell {
            
            let dict = arrTransaction[indexPath.row]
            cell.lblMilestoneName.text = dict.valueForString(key: CName)
            cell.lblPaymentDate.text = DateFormatter.dateStringFrom(timestamp:  dict.valueForDouble(key: CPaymentDate), withFormate: "dd/MM/yyyy")
            cell.lblDueDate.text =  DateFormatter.dateStringFrom(timestamp:  dict.valueForDouble(key: CDueDate), withFormate: "dd/MM/yyyy")
            cell.lblAmountPaid.text = dict.valueForString(key: CAmount)
            cell.lblAmountPayable.text = "\(self.totalPayableAmount)"
            
            //...Load More
            if indexPath == tblTransaction.lastIndexPath(){
                self.loadMilestoneList(showLoader: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK:-
//MARK:- API

extension TransactionHistoryViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadMilestoneList(showLoader: false)
    }
    
    func loadMilestoneList(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getTranscationHistory(page: currentPage, showLoader: showLoader, completion: { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            
            if response != nil {
                
                if self.currentPage == 1{
                    self.arrTransaction.removeAll()
                    self.tblTransaction.reloadData()
                }
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    
                    if arrData.count > 0 {
                        self.arrTransaction = self.arrTransaction + arrData
                        self.tblTransaction.reloadData()
                        self.currentPage += 1
                        
                        for item in arrData {
                            if item.valueForInt(key: CPaymentStatus) == CPaymentPaid {
                                self.totalPayableAmount += item.valueForInt(key: CAmount)!
                            }
                        }
                    }
                }
            }
        })
    }
}
