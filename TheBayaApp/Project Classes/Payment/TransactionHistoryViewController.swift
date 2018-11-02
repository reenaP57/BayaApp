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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        self.title = "Transaction History"
        
        arrTransaction = [["name" : "MILESTONE 1", "payment_date" : "10/12/2018", "due_date" : "12/01/2019", "amount_paid" : "12000", "amount_payable" : "1,00,000"],
        ["name" : "MILESTONE 2", "payment_date" : "10/12/2018", "due_date" : "12/01/2019", "amount_paid" : "12000", "amount_payable" : "1,00,000"],
        ["name" : "MILESTONE 3", "payment_date" : "10/12/2018", "due_date" : "12/01/2019", "amount_paid" : "12000", "amount_payable" : "1,00,000"],
        ["name" : "MILESTONE 4", "payment_date" : "10/12/2018", "due_date" : "12/01/2019", "amount_paid" : "12000", "amount_payable" : "1,00,000"],
        ["name" : "MILESTONE 5", "payment_date" : "10/12/2018", "due_date" : "12/01/2019", "amount_paid" : "12000", "amount_payable" : "1,00,000"]] as [[String : AnyObject]]
        
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
            cell.lblMilestoneName.text = dict.valueForString(key: "name")
            cell.lblPaymentDate.text = dict.valueForString(key: "payment_date")
            cell.lblDueDate.text = dict.valueForString(key: "due_date")
            cell.lblAmountPaid.text = dict.valueForString(key: "amount_paid")
            cell.lblAmountPayable.text = dict.valueForString(key: "amount_payable")
            
            return cell
        }
        
        return UITableViewCell()
    }
}
