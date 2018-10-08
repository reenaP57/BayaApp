//
//  SeeAllLocationAdvantagesViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SeeAllLocationAdvantagesViewController: ParentViewController {
    
    @IBOutlet fileprivate weak var tblLocation : UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var arrLocation = [[String : AnyObject]]()
    var projectId = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Location Advantages"
        
        refreshControl.addTarget(self, action: #selector(pulltoRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblLocation.pullToRefreshControl = refreshControl
        
        //...Load location advantages list from server
        self.loadLocationAdvantages(showLoader: true)
    }
}


//MARK:-
//MARK:- UITableview Delegate and Datsource

extension SeeAllLocationAdvantagesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SellAllLocationTblCell") as? SellAllLocationTblCell {
            
            let dict = arrLocation[indexPath.row]
            
            cell.lblLocation.text = dict.valueForString(key: CTitle)
            cell.imgVLocation.sd_setShowActivityIndicatorView(true)
            cell.imgVLocation.sd_setImage(with: URL(string: dict.valueForString(key: CIcon) ), placeholderImage: nil, options: .retryFailed, completed: nil)
            
            let arrDesc = dict.valueForString(key: CDescription).components(separatedBy:"\n")
            if arrDesc.count > 0 {
                cell.loadLocationDesc(arrDesc: arrDesc)
            }
            

            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        return UITableViewCell()
    }
}


//MARK:-
//MARK:- API

extension SeeAllLocationAdvantagesViewController {
    
    @objc func pulltoRefresh(){
        refreshControl.beginRefreshing()
        self.loadLocationAdvantages(showLoader: false)
    }
    
    func loadLocationAdvantages(showLoader : Bool) {
        
//        if !isRefresh {
//            activityLoader.startAnimating()
//        }
        
        APIRequest.shared().getLocationAdvantages(projectId: self.projectId, showLoader : showLoader) { (response, error) in
            
            self.refreshControl.endRefreshing()
         //   self.activityLoader.stopAnimating()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                if arrData.count > 0 {
                    if arrData.count != self.arrLocation.count {
                        self.arrLocation.removeAll()
                        for item in arrData {
                            self.arrLocation.append(item)
                        }
                    }
                }
                
                self.tblLocation.reloadData()
                
                GCDMainThread.async {
                    self.tblLocation.reloadData()
                }
            }
        }
    }
}
