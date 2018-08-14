//
//  TimelineDetailViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimelineDetailViewController: ParentViewController {

    @IBOutlet fileprivate weak var collProject : UICollectionView!
    @IBOutlet fileprivate weak var tblUpdates : UITableView!

    var arrProject = [[String : AnyObject]]()
    var arrUpdateList = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
    
        self.title = "the baya company"
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "filter_"), style: .plain, target: self, action: #selector(btnFilterClicked))
        
        arrProject = [["project_name": "The Baya Victoria Chembur", "percentage": "50"],["project_name": "The Baya Victoria Chembur", "percentage": "50"],["project_name": "The Baya Victoria Chembur", "percentage": "50"]] as [[String : AnyObject]]
        
        arrUpdateList = [["image": ["img1.jpeg","img2.jpeg","img3.jpeg","img4.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM","type" : "image"],
                         ["image": ["img3.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM","type" : "url"],
                         ["image": ["img4.jpeg","img2.jpeg","img3.jpeg","img4.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM", "type" : "text"]] as [[String : AnyObject]]
    }
    
    @objc func btnFilterClicked() {
        
        if let vwFilter = FilterView.viewFromXib as? FilterView {
            
            vwFilter.CViewSetHeight(height:  CScreenWidth * (vwFilter.CViewHeight / 375))

            self.presentPopUp(view: vwFilter, shouldOutSideClick: false, type: MIPopUpOverlay.MIPopUpPresentType.bottom) {
                
                vwFilter.btnDone.touchUpInside { (sender) in
                    self.dismissPopUp(view: vwFilter, completionHandler: nil)
                }
                
                vwFilter.btnClose.touchUpInside { (sender) in
                    self.dismissPopUp(view: vwFilter, completionHandler: nil)
                }
                
                vwFilter.btnClear.touchUpInside { (sender) in
                    vwFilter.txtStartDate.text = ""
                    vwFilter.txtEndDate.text = ""
                }
            }
        }
    }
    
}


//MARK:-
//MARK:- Action

extension TimelineDetailViewController {
    
    @IBAction func btnScheduleVisitClicked (sender : UIButton) {
     
        if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
            self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
        }
    }

    @IBAction func btnProjectDetailClicked (sender : UIButton) {
        
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimelineDetailViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProject.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: (CScreenWidth - 70), height: collectionView.CViewHeight )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscribedProjectCollCell", for: indexPath) as? SubscribedProjectCollCell {
            
            let dict = arrProject[indexPath.row]
            
            cell.lblProjectName.text = dict.valueForString(key: "project_name")
            cell.lblCompleted.text = "\(dict.valueForString(key: "percentage"))%"
            cell.lblPercentage.text = "\(dict.valueForString(key: "percentage"))%"
            
            cell.btnSubscribe.touchUpInside { (sender) in
                cell.btnSubscribe.isSelected = !cell.btnSubscribe.isSelected
            }
            
            cell.btnCall.touchUpInside { (sender) in
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension TimelineDetailViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUpdateList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 298
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell") as? TimeLineUpdateTblCell {
            
            let dict = arrUpdateList[indexPath.row]

            if dict.valueForString(key: "type") == "image" {
                cell.lblUrl.hide(byHeight: true)
                cell.collImg.hide(byHeight: false)
               _ = cell.lblDesc.setConstraintConstant(0, edge: .top, ancestor: true)
                cell.loadSliderImages(images: dict.valueForJSON(key: "image") as! [String])

            } else if dict.valueForString(key: "type") == "text" {
                cell.lblUrl.hide(byHeight: true)
                cell.collImg.hide(byHeight: true)
                cell.pageControlSlider.hide(byHeight: true)
                _ = cell.lblDesc.setConstraintConstant(-10, edge: .top, ancestor: true)

            } else {
                cell.lblUrl.hide(byHeight: false)
                cell.collImg.hide(byHeight: false)
                 _ = cell.lblUrl.setConstraintConstant(10, edge: .top, ancestor: true)
                cell.loadSliderImages(images: dict.valueForJSON(key: "image") as! [String])
            }
            
            if let arr = dict.valueForJSON(key: "image") as? [String] {
                cell.pageControlSlider.numberOfPages = arr.count
            }
            
            cell.lblDesc.text = dict.valueForString(key: "desc")
            cell.lblDateTime.text = dict.valueForString(key: "time")

            
            cell.btnShare.touchUpInside { (sender) in
                
                let text = "This is the text...."
                //let image = UIImage(named: "Product")
               // let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
                let shareAll = [text]
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
}
