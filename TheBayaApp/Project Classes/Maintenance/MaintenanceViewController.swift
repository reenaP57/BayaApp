//
//  MaintenanceViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MaintenanceViewController: ParentViewController {

    @IBOutlet weak var tblMaintenance : UITableView!
    @IBOutlet weak var lblNoData : UILabel!
    @IBOutlet weak var btnAddRequest : UIButton!
    
    var arrRequest = [[String : AnyObject]]()
    
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
        self.title = "Maintenance"
        
        btnAddRequest.shadow(color: ColorGreenSelected, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        
        arrRequest = [["docName" : "Pipe is Broken", "status" : CRequestOpen, "date" : "10 Sep 2018", "desc" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."],
                      ["docName" : "Flooring issue", "status" : CRequestCompleted, "date" : "10 Sep 2018", "desc" : "Lorem Ipsum is simply dummy text of the printing and typesetting industry."]] as [[String : AnyObject]]
        
        tblMaintenance.rowHeight = UITableViewAutomaticDimension
        tblMaintenance.estimatedRowHeight = 110
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension MaintenanceViewController {
    
    @IBAction func btnAddMaintenanceRequestClicked() {
        if let newMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "NewMaintenanceRequestViewController") as? NewMaintenanceRequestViewController {
            self.navigationController?.pushViewController(newMaintenanceVC, animated: true)
        }
    }
}


//MARK
//MARK:- UITableView Delegate and datasource

extension MaintenanceViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDocTblCell") as? RequestDocTblCell {
            
            let dict = arrRequest[indexPath.row]
            cell.lblDocName.text = dict.valueForString(key: "docName")
            cell.lblStatus.text = dict.valueForString(key: "status")
            cell.lblRequestedDate.text = "Requested on: \(dict.valueForString(key: "date"))"
            
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
        
        if arrRequest[indexPath.row].valueForString(key: "status") == CRequestCompleted {
            if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                rateVC.isVisitRate = false
                self.navigationController?.pushViewController(rateVC, animated: true)
            }
        } else {
            if let viewMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "ViewMaintenanceRequestViewController") as? ViewMaintenanceRequestViewController {
                viewMaintenanceVC.status = arrRequest[indexPath.row].valueForString(key: "status")
                self.navigationController?.pushViewController(viewMaintenanceVC, animated: true)
            }
        }
    }
}
