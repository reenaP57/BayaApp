//
//  TimelineDetailViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

let space = CScreenWidth * 70/375

class TimelineDetailViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblUpdates : UITableView!

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

        arrUpdateList = [["image": ["img1.jpeg","img2.jpeg","img3.jpeg","img4.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM","type" : "image"],
                         ["image": ["img3.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM","type" : "url"],
                         ["image": ["img4.jpeg","img2.jpeg","img3.jpeg","img4.jpeg"], "desc": "Construction of 5 the floor is done, check the progress here through the image here.", "time" : "Yesterday at 12:00 PM", "type" : "text"]] as [[String : AnyObject]]
    }
    
    @objc func btnFilterClicked() {
        
        if let vwFilter = FilterView.viewFromNib(is_ipad: false) as? FilterView {
            
            vwFilter.frame = CGRect(x: 0, y: 0 , width: CScreenWidth, height: CScreenHeight)
            vwFilter.vwContent.frame = CGRect(x: 0, y: CScreenHeight - (CScreenWidth * (vwFilter.CViewHeight / 375)) , width: CScreenWidth, height: CScreenWidth * (vwFilter.CViewHeight / 375))
          
            vwFilter.vwContent.roundCorners([.topLeft, .topRight], radius: 30)

            UIView.animate(withDuration: 1.0) {
                appDelegate.window.addSubview(vwFilter)
            }
            
            vwFilter.btnDone.touchUpInside { (sender) in
               vwFilter.removeFromSuperview()
            }
            
            vwFilter.btnClose.touchUpInside { (sender) in
                vwFilter.removeFromSuperview()
            }
            
            vwFilter.btnClear.touchUpInside { (sender) in
                vwFilter.txtStartDate.text = ""
                vwFilter.txtEndDate.text = ""
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
        
        if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
            self.navigationController?.pushViewController(projectDetailVC, animated: true)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension TimelineDetailViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUpdateList.count + 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 298
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineSubscribeTblCell") as? TimeLineSubscribeTblCell {
                return cell
            }
            
            return UITableViewCell()
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell") as? TimeLineUpdateTblCell {
                
                let dict = arrUpdateList[indexPath.row - 1]
                
                if dict.valueForString(key: "type") == "image" {
                    cell.lblUrl.hide(byHeight: true)
                    cell.collImg.hide(byHeight: false)
                    cell.pageControlSlider.hide(byHeight: false)
                    
                    _ = cell.lblDesc.setConstraintConstant(IS_iPad ? 7 : 0, edge: .top, ancestor: true)
                    cell.loadSliderImages(images: dict.valueForJSON(key: "image") as! [String])
                    
                } else if dict.valueForString(key: "type") == "text" {
                    cell.lblUrl.hide(byHeight: true)
                    cell.collImg.hide(byHeight: true)
                    cell.pageControlSlider.hide(byHeight: true)
                    _ = cell.lblDesc.setConstraintConstant(-10, edge: .top, ancestor: true)
                    
                } else {
                    cell.lblUrl.hide(byHeight: false)
                    cell.collImg.hide(byHeight: false)
                    cell.pageControlSlider.hide(byHeight: true)
                    
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
}
