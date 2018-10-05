//
//  HomeViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class HomeViewController: ParentViewController {

    @IBOutlet fileprivate weak var collHome : UICollectionView!
    var arrHome = [[String : AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
        
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CHomeScreenName)
        self.userDetail()
        self.initialize()
        collHome.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
       
        arrHome = [["title": "Timeline" as AnyObject, "subtitle":  appDelegate.loginUser?.project_name as AnyObject, "img": IS_iPad ? "timeline_ipad" as AnyObject : "timeline" as AnyObject],
                   ["title": "Projects" as AnyObject, "subtitle": "\(appDelegate.loginUser?.projectBadge as AnyObject)", "img": IS_iPad ? "projects_ipad" as AnyObject : "projects" as AnyObject],
                   ["title": "Schedule a Visit" as AnyObject, "subtitle": "CHOOSE TIME OF VISIT" as AnyObject, "img": IS_iPad ? "schedule_visit_ipad" as AnyObject : "schedule_visit" as AnyObject]] as [[String : AnyObject]]
    }
    
    func userDetail() {
        APIRequest.shared().userDetail { (response, error) in
            if response != nil && error == nil {
                self.initialize()
                self.collHome.reloadData()
            }
        }
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension HomeViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHome.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {

        return IS_iPad ? CGSize(width: (CScreenWidth/2 - 40), height: (CScreenWidth * (300/768))): CGSize(width: (CScreenWidth/2 - 20), height:(CScreenWidth * (220 / 375)))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict = arrHome[indexPath.row]
        
        if indexPath.item == 0 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineHomeCollCell", for: indexPath) as? TimelineHomeCollCell {
                
                cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.lblPrjctName.text = (dict.valueForString(key: "subtitle")).uppercased()
                cell.lblBadge.text = "\(appDelegate.loginUser?.postBadge ?? 0)"
                cell.lblPercentage.text = "\(appDelegate.loginUser?.projectProgress ?? 0)% Completed"
                
                cell.progressVCom.progressImage = UIImage(named: "progress")
                let temp =  Double((appDelegate.loginUser?.projectProgress)!)
                let invertedValue = temp/100
                cell.progressVCom.setProgress(Float(invertedValue), animated: false)
                
                cell.vwCount.isHidden = appDelegate.loginUser?.postBadge == 0
                
                if appDelegate.loginUser?.fav_project_id == 0 {
                    
                    cell.vwProgress.isHidden = true
                    _ = cell.imgVTitle.setConstraintConstant(50, edge: .top, ancestor: true)
                }
                
                return cell
            }
        } else {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath) as? HomeCollCell {
                
                cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.lblPrjctName.text = (dict.valueForString(key: "subtitle")).uppercased()
             
                if indexPath.row == 1 {
                    cell.lblPrjctName.isHidden = dict.valueForString(key: "subtitle") == "0"
                    if appDelegate.loginUser?.projectBadge == 0 || appDelegate.loginUser?.projectBadge == 1 {
                        cell.lblPrjctName.text = "\(dict.valueForString(key: "subtitle")) PROJECT"
                    } else {
                        cell.lblPrjctName.text = "\(dict.valueForString(key: "subtitle")) PROJECTS"
                    }
                } else {
                    cell.lblPrjctName.isHidden = false
                }
                
                return cell
            }
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0: //...Timeline
            MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "TimeLine")
            
            if let timeLineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                self.navigationController?.pushViewController(timeLineVC, animated: true)
            }
        case 1: //...Project
            MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "Project")

            if let projectVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController {
                self.navigationController?.pushViewController(projectVC, animated: true)
            }
            
        default: //...Schedule Visit
            MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "Schedule Visit")

            if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
                self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
            }
        }
    }
}
