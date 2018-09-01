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
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        
        if IS_iPad {
            arrHome = [["title": "Timeline", "subtitle": "THE BAYA VICTORIA", "img": "timeline_ipad"],["title": "Projects", "subtitle": "5 PROJECTS", "img": "projects_ipad"],["title": "Schedule a Visit", "subtitle": "CHOOSE TIME OF VISIT", "img": "schedule_visit_ipad"]] as [[String : AnyObject]]

        } else {
            arrHome = [["title": "Timeline", "subtitle": "THE BAYA VICTORIA", "img": "timeline"],["title": "Projects", "subtitle": "5 PROJECTS", "img": "projects"],["title": "Schedule a Visit", "subtitle": "CHOOSE TIME OF VISIT", "img": "schedule_visit"]] as [[String : AnyObject]]

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
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath) as? HomeCollCell {
            
            let dict = arrHome[indexPath.row]
            
            cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
            cell.lblTitle.text = dict.valueForString(key: "title")
            cell.lblPrjctName.text = dict.valueForString(key: "subtitle")
            
            
            if indexPath.row != 0 {
               cell.vwProgress.hide(byHeight: true)
                
                if IS_iPad {
                    _ = cell.lblPrjctName.setConstraintConstant(30, edge: .bottom, ancestor: true)
                }
            }
            
            // cell.vwCount.isHidden = indexPath.row != 0
            //cell.vwProgress.isHidden = indexPath.row != 0
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            if let timeLineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                self.navigationController?.pushViewController(timeLineVC, animated: true)
            }
        case 1:
            if let projectVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController {
                self.navigationController?.pushViewController(projectVC, animated: true)
            }
            
        default:
            if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
                self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
            }
        }
    }
}
