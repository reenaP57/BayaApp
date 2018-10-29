//
//  RequestDocumentListViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class RequestDocumentListViewController: ParentViewController {

    @IBOutlet weak var tblRequestDoc : UITableView!
    @IBOutlet weak var lblNoData : UILabel!
    @IBOutlet weak var btnAddRequest : UIButton!

    var arrRequest = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Request a Document"
        
        btnAddRequest.shadow(color: ColorGreenSelected, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        
        arrRequest = [["docName" : "NOC Doc", "status" : CRequestOpen, "date" : "10 Sep 2018", "desc" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."],
        ["docName" : "RERA Doc", "status" : CRequestCompleted, "date" : "10 Sep 2018", "desc" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry."],
        ["docName" : "RERA Doc", "status" : CRequestInProgress, "date" : "10 Sep 2018", "desc" : "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"],
        ["docName" : "RERA Doc", "status" : CRequestRejected, "date" : "10 Sep 2018", "desc" : "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."]] as [[String : AnyObject]]
        
        tblRequestDoc.rowHeight = UITableViewAutomaticDimension
        tblRequestDoc.estimatedRowHeight = 110
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension RequestDocumentListViewController {
   
    @IBAction func btnAddRequestClicked() {
        if let addRequestVC = CStoryboardDocument.instantiateViewController(withIdentifier: "AddRequestDocViewController") as? AddRequestDocViewController {
            self.navigationController?.pushViewController(addRequestVC, animated: true)
        }
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension RequestDocumentListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDocTblCell") as? RequestDocTblCell {
            
            let dict = arrRequest[indexPath.row]
            cell.lblDocName.text = dict.valueForString(key: "docName")
            cell.lblStatus.text = dict.valueForString(key: "status")
            cell.lblRequestedDate.text = "Requested on : \(dict.valueForString(key: "date"))"
            
            switch dict.valueForString(key: "status") {
            case CRequestOpen : //...Open
                cell.vwStatus.backgroundColor = ColorParrotColor
            case CRequestCompleted : //...Completed
                cell.vwStatus.backgroundColor = ColorGreenSelected
            case CRequestInProgress : //...In Progress
                cell.vwStatus.backgroundColor = ColorOrange
            default : //...Rejected
                cell.vwStatus.backgroundColor = ColorRed
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewRequestVC = CStoryboardDocument.instantiateViewController(withIdentifier: "ViewRequestViewController") as? ViewRequestViewController {
            viewRequestVC.dictRequest = arrRequest[indexPath.row]
            self.navigationController?.pushViewController(viewRequestVC, animated: true)
        }
    }
}
