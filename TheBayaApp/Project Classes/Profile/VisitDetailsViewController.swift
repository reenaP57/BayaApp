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
        
        //...Load Visit detail list
        self.loadVisitList(showLoader: true, isFromNotification : false)

        if IS_iPhone {
            tblVVisitDetails.estimatedRowHeight = 125
            tblVVisitDetails.rowHeight = UITableViewAutomaticDimension
        }

    }
    
    func RefreshRatingVisit(visitId : Int, rating : Int) {
        
        //...Refresh Particular visit when rating is done
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let dict = arrVisitList[indexPath.row]

        if IS_iPad {
            if dict.valueForInt(key: "visitStatus") == CScheduled || dict.valueForInt(key: "visitStatus") == CRescheduled {
                return CScreenWidth * 250/768
            } else {
                return CScreenWidth * 155/768
            }
        }

        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = arrVisitList[indexPath.row]
        
        if dict.valueForInt(key: "visitStatus") == CScheduled ||  dict.valueForInt(key: "visitStatus") == CRescheduled {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitConfirmTblCell") as? VisitConfirmTblCell {
                
                cell.lblProjectName.text = dict.valueForString(key: CProjectName)
                
                if dict.valueForInt(key: "visitStatus") == CScheduled  {
                    cell.lblTimeMsg.text = "\(CMessageScheduled) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))."
                } else {
                    cell.lblTimeMsg.text = "\(CMessageRescheduled) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))."
                }
                
                cell.lblUserName.text = dict.valueForString(key: "salesMgrName")
                cell.lblLocation.text = dict.valueForString(key: "siteAddress")
                cell.btnCall.setTitle(dict.valueForString(key: "salesMgrContact"), for: .normal)
                
                cell.imgVProject.sd_setShowActivityIndicatorView(true)
                cell.imgVProject.sd_setImage(with: URL(string: (dict.valueForString(key: CProjectImage))), placeholderImage: nil)
                
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                
                cell.btnCall.touchUpInside { (sender) in
                    self.dialPhoneNumber(phoneNumber: (dict.valueForString(key: "salesMgrContact")))
                }
                
                return cell
            }
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailTblCell") as? VisitDetailTblCell {
                
                cell.lblProjectName.text = dict.valueForString(key: CProjectName)
                cell.vwRating.rating = Double(dict.valueForInt(key: "ratings")!)
                
                cell.imgVProject.sd_setShowActivityIndicatorView(true)
                cell.imgVProject.sd_setImage(with: URL(string: (dict.valueForString(key: CProjectImage))), placeholderImage: nil)
                
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear

                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
                cell.vwTagLbl.isHidden = true
                cell.imgVTickMark.hide(byWidth: true)
                
                switch dict.valueForInt(key: "visitStatus") {
                case CRequested :
                    cell.lblTimeMsg.text = CMessageRequested
                    cell.vwTagLbl.isHidden = false
                    cell.lblTag.text = "UNCONFIRMED"
                    cell.vwTagLbl.backgroundColor = ColorGradient2Background
                    
                    
                case CCompleted:
                    cell.lblTimeMsg.text = "\(CMessageCompleted) \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a"))."
                    
                    cell.btnRateVisit.isHidden = dict.valueForInt(key: "ratings") != 0
                    cell.vwRating.isHidden = dict.valueForInt(key: "ratings") == 0
                    cell.btnRateVisit.isHidden = false
                    cell.vwRating.isHidden = false
                    cell.imgVTickMark.hide(byWidth: false)
                    
                default : //...Cancelled
                    
                    if dict.valueForDouble(key: "selectedTimeSlot") == 0 {
                        cell.lblTimeMsg.text = "Your visit request has been cancelled."
                    } else {
                        cell.lblTimeMsg.text = "Your visit scheduled on \(DateFormatter.dateStringFrom(timestamp: (dict.valueForDouble(key: "selectedTimeSlot")), withFormate: "dd MMMM yyyy hh:mm a")) has been cancelled."
                    }
                    
                    cell.vwTagLbl.isHidden = false
                    cell.lblTag.text = "CANCELLED"
                    cell.vwTagLbl.backgroundColor = CRGB(r: 255, g: 69, b: 77)
        
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
        self.loadVisitList(showLoader: false, isFromNotification : false)
    }
    
    
    func loadVisitList(showLoader : Bool, isFromNotification : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
//        if !isRefresh {
//            activityLoader.startAnimating()
//        }
        
        if isFromNotification {
           currentPage = 1
        }
        
        apiTask =  APIRequest.shared().getVisitList(page: self.currentPage, showLoader: showLoader) { (response, error) in
            
            self.apiTask?.cancel()
        //    self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {

                if self.currentPage == 1{
                    self.arrVisitList.removeAll()
                }
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    if arrData.count > 0 {
                        self.arrVisitList = arrData
                    }
                }
              
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    self.lastPage = metaData.valueForInt(key: CLastPage)!
                    
                    if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                        self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                    }
                }
             
                self.lblNoData.isHidden = self.arrVisitList.count != 0
                self.tblVVisitDetails.reloadData()
            }
        }
    }
}
