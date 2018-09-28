//
//  ProjectViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProjectViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblProject : UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    
    var arrProject = [[String : AnyObject]]()
    
    fileprivate var lastPage : Int = 0
    fileprivate var currentPage : Int = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CProjectListScreenName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        self.title = "The Baya Projects"
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblProject?.pullToRefreshControl = refreshControl
        
        self.loadProjectList(isRefresh: false, isFromNotification :false)

        if IS_iPhone {
            tblProject.estimatedRowHeight = 170
            tblProject.rowHeight = UITableViewAutomaticDimension
        } else {
            tblProject.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        }
    }
    
    
    func refreshIsSubscribedStatus(projectId : Int, isSubscribed : Int) {
        
        for (index, _) in self.arrProject.enumerated() {
            
            let dict = self.arrProject[index]
            
            if dict.valueForInt(key: CProjectId) == projectId {
                
                var updatedDict = dict
                updatedDict[CIsSubscribe] = isSubscribed as AnyObject
                self.arrProject[index] = updatedDict
                tblProject.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource


extension ProjectViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProject.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTblCell") as? ProjectTblCell {
            
            var dict = arrProject[indexPath.row]
      
            cell.lblPjctName.text = dict.valueForString(key: CProjectName)
            cell.lblLocation.text = dict.valueForString(key: "shortLocation")
            cell.lblReraNo.text = dict.valueForString(key: CReraNumber)
            
            if IS_iPad {
                cell.lblDesc.text = dict.valueForString(key: CDescription)
            }
            
            cell.imgVPrjct.sd_setShowActivityIndicatorView(true)
            cell.imgVPrjct.sd_setImage(with: URL(string: (dict.valueForString(key: CProjectImage))), placeholderImage: nil)
            
            if dict.valueForInt(key: CIsSubscribe) == 0 {
                cell.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg2"),for: .normal)
                cell.btnSubscribe.isSelected = false
            } else {
                cell.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg1"), for: .normal)
                cell.btnSubscribe.isSelected = true
            }
            
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            cell.btnSubscribe.touchUpInside { (sender) in
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: sender.isSelected ? CUnsubscribeMessage : CSubscribeMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                  
                    cell.btnSubscribe.isSelected ? cell.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg1"), for: .normal) : cell.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg2"), for: .normal)
                    
                    cell.btnSubscribe.isSelected = !cell.btnSubscribe.isSelected
                    
                    if cell.btnSubscribe.isSelected {
                        MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "Project Subscribe")
                    } else {
                        MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "Project Unsubscribe")
                    }
                    

                    APIRequest.shared().subcribedProject(dict.valueForInt(key: CProjectId)!, type: cell.btnSubscribe.isSelected ? 1 : 0) { (response, error) in
                        
                        if response != nil && error == nil {
                            
                            let data = response?.value(forKey: CJsonData) as! [String : AnyObject]
                            
                            dict[CIsSubscribe] = data.valueForInt(key: CIsSubscribe) as AnyObject
                            self.arrProject[indexPath.row] = dict
                            self.tblProject.reloadRows(at: [indexPath], with: .none)
                            
                            appDelegate.loginUser?.postBadge = Int16(data.valueForInt(key: CFavoriteProjectBadge)!)
                            appDelegate.loginUser?.projectProgress = Int16(data.valueForInt(key: CFavoriteProjectProgress)!)
                            appDelegate.loginUser?.project_name = data.valueForString(key: CFavoriteProjectName)
                            
                            CoreData.saveContext()
                        }
                    }
                    
                }, btnTwoTitle: CBtnCancel, btnTwoTapped: { (action) in
                })
            }
            
            
            if indexPath == tblProject.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadProjectList(isRefresh: true, isFromNotification :false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dict = arrProject[indexPath.row]
        
        if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
            projectDetailVC.projectID = dict.valueForInt(key: CProjectId)!
            self.navigationController?.pushViewController(projectDetailVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- API


extension ProjectViewController {
    
    @objc func pullToRefresh(){
        currentPage = 1
        self.refreshControl.beginRefreshing()
        self.loadProjectList(isRefresh: true, isFromNotification :false)
    }
    
    func loadProjectList(isRefresh : Bool, isFromNotification :Bool) {
     
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            activityLoader.startAnimating()
        }
        
        apiTask = APIRequest.shared().getProjectList(currentPage, completion: { (response, error) in
        
            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrProject.removeAll()
                }
                
                if arrData.count > 0 {
                    
                    for item in arrData {
                        self.arrProject.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.tblProject.reloadData()
                
            } 
        })
    }
    
}
