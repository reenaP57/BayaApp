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
    
    var apiTask : URLSessionTask?
    var refreshControl = UIRefreshControl()
    var arrRequest = [[String : AnyObject]]()
    var currentPage = 1
    
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

        refreshControl.tintColor = ColorGreenSelected
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblMaintenance.pullToRefreshControl = refreshControl
        
        tblMaintenance.rowHeight = UITableViewAutomaticDimension
        tblMaintenance.estimatedRowHeight = 110
        
        self.loadMaintenanceRequestList(showLoader: true)
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
            cell.lblDocName.text = dict.valueForString(key: "subject")
            cell.lblRequestedDate.text = "Requested on: \(DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "createdAt")!, withFormate: "dd MMM yyyy"))"
            
            switch dict.valueForInt(key: "requestStatus") {
            case CRequestOpen : //...Open
                cell.vwStatus.backgroundColor = ColorParrotColor
                cell.lblStatus.text = CDocRequestOpen
            case CRequestCompleted : //...Completed
                cell.vwStatus.backgroundColor = ColorGreenSelected
                cell.lblStatus.text = CDocRequestCompleted
            case CRequestInProgress : //...In Progress
                cell.vwStatus.backgroundColor = ColorOrange
                cell.lblStatus.text = CDocRequestInProgress
            case CRequestRejected : //...Rejected
                cell.vwStatus.backgroundColor = ColorRed
                cell.lblStatus.text = CDocRequestRejected
            default :
                break
            }

            
            //...Load More
            if indexPath == tblMaintenance.lastIndexPath() {
                self.loadMaintenanceRequestList(showLoader: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // if arrRequest[indexPath.row].valueForInt(key: "requestStatus") == CRequestCompleted && (!arrRequest[indexPath.row].valueForBool(key: "isRatingSkip") || arrRequest[indexPath.row].valueForInt(key: "rating") == 0) {
        
        if arrRequest[indexPath.row].valueForInt(key: "requestStatus") == CRequestCompleted && (!arrRequest[indexPath.row].valueForBool(key: "isRatingSkip") && arrRequest[indexPath.row].valueForInt(key: "rating") == 0) {
            //...Redirect on Rating screen If Request status is completed and user has not skiped rating or not given yet rating
            
            if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                rateVC.isVisitRate = false
                rateVC.visitId = arrRequest[indexPath.row].valueForInt(key: CId) ?? 0
                self.navigationController?.pushViewController(rateVC, animated: true)
            }
        } else {
            if let viewMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "ViewMaintenanceRequestViewController") as? ViewMaintenanceRequestViewController {
                viewMaintenanceVC.requestID = arrRequest[indexPath.row].valueForInt(key: CId) ?? 0
                self.navigationController?.pushViewController(viewMaintenanceVC, animated: true)
            }
        }
    }
}

//MARK:-
//MARK:- API

extension MaintenanceViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadMaintenanceRequestList(showLoader: false)
    }
    
    func loadMaintenanceRequestList(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getMaintenanceRequestList(page: currentPage, shouldShowLoader: showLoader, completion: { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            if response != nil {

                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    
                    if self.currentPage == 1{
                        self.arrRequest.removeAll()
                        self.tblMaintenance.reloadData()
                    }
                    
                    if arrData.count > 0 {
                        self.arrRequest = self.arrRequest + arrData
                        self.tblMaintenance.reloadData()
                        self.currentPage += 1
                    }
                }
                
                self.lblNoData.isHidden = self.arrRequest.count != 0
            }
        })
    }
}
