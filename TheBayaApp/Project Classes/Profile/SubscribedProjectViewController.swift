//
//  SubscribedProjectViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SubscribedProjectViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblSubscribedList : UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
    @IBOutlet fileprivate weak var imgVBg : UIImageView!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrSubscribeList = [[String : AnyObject]]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CSubscribedProjectsScreenName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        self.title = "Subscribed Projects"
        
        tblSubscribedList.rowHeight = UITableViewAutomaticDimension
        tblSubscribedList.estimatedRowHeight = 110
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblSubscribedList.pullToRefreshControl = refreshControl
        self.loadSubscribedProject(isRefresh: false)
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension SubscribedProjectViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscribeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribedTblCell") as? SubscribedTblCell {
            
            let dict = arrSubscribeList[indexPath.row]
            cell.lblProjectName.text = dict.valueForString(key: CProjectName)
            cell.lblAddress.text = dict.valueForString(key: CAddress)
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            cell.btnUnsubscribe.setBackgroundImage(UIImage(named: "gradient_bg1"), for: .normal)
            
            cell.btnUnsubscribe.touchUpInside { (sender) in
                
                self.showAlertConfirmationView(CUnsubscribeMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        
                        APIRequest.shared().subcribedProject(dict.valueForInt(key: CProjectId), type: 0,completion: { (response, error) in
                            
                            if response != nil && error == nil {
                                
                                self.arrSubscribeList.remove(at: indexPath.row)
                                self.lblNoData.isHidden = self.arrSubscribeList.count != 0
                                self.tblSubscribedList.reloadData()
                            }
                        })
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

}


//MARK:-
//MARK:- API

extension SubscribedProjectViewController {
    
    @objc func pullToRefresh(){
        refreshControl.beginRefreshing()
        self.loadSubscribedProject(isRefresh: true)
    }
    
    func loadSubscribedProject(isRefresh : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
//        if !isRefresh {
//            activityLoader.startAnimating()
//        }
        
        apiTask = APIRequest.shared().getSubscribedProjectList(showLoader: !isRefresh, completion: { (response, error) in
            
            self.apiTask?.cancel()
           // self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                self.imgVBg.isHidden = false
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    if arrData.count > 0 {
                        if arrData.count != self.arrSubscribeList.count {
                            self.arrSubscribeList.removeAll()
                            self.arrSubscribeList = arrData
                        }
                    }
                }
                
                self.lblNoData.isHidden = self.arrSubscribeList.count != 0
                self.tblSubscribedList.reloadData()
            } else {
                self.imgVBg.isHidden = true
            }
        })
    }
}
