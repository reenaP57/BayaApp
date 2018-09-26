//
//  VisitDetailsViewController.swift
//  TheBayaApp
//
//  Created by Mind-0006 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VisitDetailsViewController: ParentViewController {

    @IBOutlet weak var tblVVisitDetails: UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
    
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var lastPage = 0
    var currentPage = 1
    
    var arrVisitList = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CVisitDetailScreenName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.navigationItem.title = "Visit Details"
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblVVisitDetails.pullToRefreshControl = refreshControl
        
        self.loadVisitList(isRefresh: false, isFromNotification : false)

        if IS_iPhone {
            tblVVisitDetails.estimatedRowHeight = 125
            tblVVisitDetails.rowHeight = UITableViewAutomaticDimension
        } else {
             tblVVisitDetails.rowHeight = CScreenWidth * 155/768
        }
    }
    
    func RefreshRatingVisit(visitId : Int, rating : Int) {
        
        print("arrVisitList : ",self.arrVisitList)
        
        
        for (index, _) in self.arrVisitList.enumerated() {
            
            let dict = self.arrVisitList[index]
            
            if dict.valueForInt(key: "visitId") == visitId {
                
                var updatedDict = dict
                updatedDict["ratings"] = rating as AnyObject
                self.arrVisitList[index] = updatedDict
                tblVVisitDetails.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension VisitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVisitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailTblCell") as? VisitDetailTblCell {
            
            let dict = arrVisitList[indexPath.row]
            
            cell.lblProjectName.text = dict.valueForString(key: CProjectName)
            cell.vwRating.rating = Double(dict.valueForInt(key: "ratings")!)
            
            cell.imgVProject.sd_setShowActivityIndicatorView(true)
            cell.imgVProject.sd_setImage(with: URL(string: (dict.valueForString(key: CProjectImage))), placeholderImage: nil)
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            
            switch dict.valueForInt(key: "visitStatus") {
            case CRequested :
                cell.lblTimeMsg.text = CMessageRequested
                _ = cell.lblTimeMsg.setConstraintConstant(10, edge: .centerY, ancestor: true)
                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
             
            case CScheduled:
                cell.lblTimeMsg.text = "\(CMessageScheduled) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))"
                
                _ = cell.lblTimeMsg.setConstraintConstant(10, edge: .centerY, ancestor: true)
                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
                

            case CCompleted:
                cell.lblTimeMsg.text = "\(CMessageCompleted) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))"
                
                cell.btnRateVisit.isHidden = dict.valueForInt(key: "ratings") != 0
                cell.vwRating.isHidden = dict.valueForInt(key: "ratings") == 0
                
            case CCancel :
                
                if dict.valueForDouble(key: "selectedTimeSlot") == 0 {
                    cell.lblTimeMsg.text = "Your visit request has been cancelled."
                } else {
                    cell.lblTimeMsg.text = "Your visit scheduled on \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a")) has been cancelled."
                }
                
                
                _ = cell.lblTimeMsg.setConstraintConstant(10, edge: .centerY, ancestor: true)
                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
                
                
            default : //Reschedule
                
                cell.lblTimeMsg.text = "\(CMessageScheduled) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))"
                
                _ = cell.lblTimeMsg.setConstraintConstant(10, edge: .centerY, ancestor: true)
                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
                
                break
            }
            
            
            cell.btnRateVisit.touchUpInside { (sender) in
                
                if let rateVisitVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                    rateVisitVC.visitId = dict.valueForInt(key: "visitId")!
                    self.navigationController?.pushViewController(rateVisitVC, animated: true)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

//MARK:-
//MARK:- API

extension VisitDetailsViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadVisitList(isRefresh: true, isFromNotification : false)
    }
    
    
    func loadVisitList(isRefresh : Bool, isFromNotification : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            activityLoader.startAnimating()
        }
        
        if isFromNotification {
           currentPage = 1
        }
        
        apiTask =  APIRequest.shared().getVisitList(page: self.currentPage) { (response, error) in
            
            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]

                if self.currentPage == 1{
                    self.arrVisitList.removeAll()
                }
                
                if arrData.count > 0 {
                    for item in arrData {
                        self.arrVisitList.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.lblNoData.isHidden = self.arrVisitList.count != 0
                self.tblVVisitDetails.reloadData()
            }
        }
    }
}
