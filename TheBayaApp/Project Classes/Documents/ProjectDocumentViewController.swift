//
//  ProjectDocumentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProjectDocumentViewController: ParentViewController {

    @IBOutlet weak var tblMyDoc : UITableView!
    @IBOutlet weak var lblNoData : UILabel!

    var arrDocument = [String]()
    var isFromMyDoc : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        if isFromMyDoc {
             self.title = "My Documents"
            arrDocument = ["Allotment Letter", "Booking Form", "Inquiry Document", "Agreement for Sale", "Invoices & Receipts"]

        } else {
             self.title = "Project Documents"
            arrDocument = ["RERA Document", "Occupancy Certificate", "Permissions", "Commencement Certificate", "IOD", "Others"]
        }
    }
}


//MARK
//MARK:- UITableView Delegate and datasource

extension ProjectDocumentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDocument.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (84 / 768) : CScreenWidth * (74 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTblCell") as? DocumentTblCell {
            cell.lblTitle.text = arrDocument[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}
