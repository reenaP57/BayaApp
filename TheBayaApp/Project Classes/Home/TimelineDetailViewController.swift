//
//  TimelineDetailViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit

let space = CScreenWidth * 70/375
let IpadSpace = CScreenWidth - (CScreenWidth * 450/768)
let NavigationBarHeight = 64

class TimelineDetailViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblUpdates : UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var btnProjectDetail : UIButton!


    var arrUpdateList = [[String : Any]]()
    var arrProject = [[String : AnyObject]]()
    var currentIndex = 0
    var pageIndexForApi = 0
    
    var apiTask : URLSessionTask?
    var refreshControl : UIRefreshControl?
    
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
    
        self.title = "Timeline"
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "filter_"), style: .plain, target: self, action: #selector(btnFilterClicked))

        tblUpdates.estimatedRowHeight = 100;
        tblUpdates.rowHeight = UITableViewAutomaticDimension;
        
        
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl?.tintColor = ColorGreenSelected
        tblUpdates.pullToRefreshControl = refreshControl
        self.loadSubscribedProjectList(isRefresh: false)
        
        if IS_iPad {
            tblUpdates.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        }
        
        
        if CUserDefaults.string(forKey: UserDefaultOpenedTimeLine) != "true"
        {
            //... For TimeLine Guide Screen
            
            if let vwTimlineGuideline = TimelineGuideLineView.viewFromNib(is_ipad: true) as? TimelineGuideLineView {
                
                vwTimlineGuideline.frame = CGRect(x: 0, y: 0 , width: CScreenWidth, height: CScreenHeight)
           
                vwTimlineGuideline.cnstImgvCheckmarkY.constant = 80
                vwTimlineGuideline.cnstImgvCheckmarkTrailing.constant = IS_iPad ?  CGFloat(IpadSpace) : space-3
                
                if !IS_iPad {
                    if IS_iPhone_5 {
                        vwTimlineGuideline.cnstImgvArrowTrailing.constant = -space + vwTimlineGuideline.imgVArrow.CViewWidth-7
                    } else if IS_iPhone_6 {
                        vwTimlineGuideline.cnstImgvArrowTrailing.constant = -space + vwTimlineGuideline.imgVArrow.CViewWidth
                    } else if IS_iPhone_6_Plus{
                        vwTimlineGuideline.cnstImgvArrowTrailing.constant = -space + vwTimlineGuideline.imgVArrow.CViewWidth+7
                    } else {
                        vwTimlineGuideline.cnstImgvArrowTrailing.constant = -space + vwTimlineGuideline.imgVArrow.CViewWidth+3
                    }
                }
                
          
                UIView.animate(withDuration: 1.0) {
                    appDelegate.window.addSubview(vwTimlineGuideline)
                }
                
                vwTimlineGuideline.btnGotIt.touchUpInside { (sender) in
                    vwTimlineGuideline.removeFromSuperview()
                    CUserDefaults.set("true", forKey: UserDefaultOpenedTimeLine)
                    CUserDefaults.synchronize()
                }
      
            }
        }
        
    }
    
    @objc func btnFilterClicked() {
        
        if let vwFilter = FilterView.viewFromNib(is_ipad: true) as? FilterView {
            
            vwFilter.frame = CGRect(x: 0, y: 0 , width: CScreenWidth, height: CScreenHeight)
            
            if IS_iPad {
                vwFilter.vwContent.frame = CGRect(x: CScreenCenter.x, y: CScreenCenter.y , width: vwFilter.vwContent.CViewWidth, height: vwFilter.vwContent.CViewHeight)
                vwFilter.vwContent.layer.cornerRadius = 30

            } else {
                vwFilter.vwContent.frame = CGRect(x: 0, y: CScreenHeight - (CScreenWidth * (vwFilter.CViewHeight / 375)) , width: CScreenWidth, height: CScreenWidth * (vwFilter.CViewHeight / 375))
                vwFilter.vwContent.roundCorners([.topLeft, .topRight], radius: 30)
            }
          
            
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
    
    func shareContent() {
       
        let text = "This is the text...."
        let shareAll = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}



//MARK:-
//MARK:-

extension TimelineDetailViewController : subscribeProjectListDelegate {
   
    func reloadTimelineList(index: Int) {
        currentIndex = index
        pageIndexForApi = 1
        
        arrUpdateList.removeAll()
        self.tblUpdates.reloadSections(IndexSet(integersIn: 1...1), with: .none)
        self.loadTimeLineListFromServer(true)
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension TimelineDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            if arrProject.count > 0 {
                let dict = arrProject[currentIndex]
                return dict.valueForInt(key: CProjectProgress) == 100 ?   2 : 1
            }
            return  0
        }else{
            return arrUpdateList.count
        }
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineSubscribeTblCell") as? TimeLineSubscribeTblCell {
                    cell.loadProjectList(arr: arrProject, selectedIndex: currentIndex)
                    cell.delegate = self
                    return cell
                }
            } else if indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCompletedProjectTblCell") as? TimelineCompletedProjectTblCell {
                    return cell
                }
            }
        } else {
            
            if indexPath == self.tblUpdates.lastIndexPath(){
                if self.apiTask != nil{
                    if self.apiTask?.state != .running{
                        print("Load more data ====== ")
                        self.loadTimeLineListFromServer(false)
                    }
                }
            }
            
            let dict = arrUpdateList[indexPath.row]
            
            if IS_iPad {
                
                switch dict.valueForInt(key: "type") {
                case 1,3: // Image
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell_ipad") as? TimeLineUpdateTblCell_ipad {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")

                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            if arrImages.count > 0{
                                cell.imgVUpdate.sd_setShowActivityIndicatorView(true)
                                cell.imgVUpdate.sd_setImage(with: URL(string: arrImages.first!), placeholderImage: nil, options: .retryFailed, completed: nil)
                                cell.loadSliderImages(images: arrImages)
                            }
                        }
                        
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        return cell
                    }
                    
                case 2: // ViDEO
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineUpdateVideoTblCell") as? TimelineUpdateVideoTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")

                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        cell.btnPlay.touchUpInside { (action) in
                            if let arrVideos = dict.valueForJSON(key: "media") as? [String] {
                                if arrVideos.count > 0{
                                    let videoURL = URL(string: arrVideos.first!)
                                    let player = AVPlayer(url: videoURL!)
                                    let playerViewController = AVPlayerViewController()
                                    playerViewController.player = player
                                    self.present(playerViewController, animated: true) {
                                        playerViewController.player!.play()
                                    }
                                }
                            }
                        }
                        
                        return cell
                    }
                
                    case 4: // URL
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateUrlTblCell_ipad") as? TimeLineUpdateUrlTblCell_ipad {
                            
                            cell.lblDesc.text = dict.valueForString(key: "description")
                            cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                            cell.lblUrl.text = dict.valueForString(key: "link")
                            
                            if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                                cell.imgVUpdate.sd_setShowActivityIndicatorView(true)
                                cell.imgVUpdate.sd_setImage(with: URL(string: arrImages.first!), placeholderImage: nil, options: .retryFailed, completed: nil)
                            }
                            
                            cell.btnShare.touchUpInside { (sender) in
                                self.shareContent()
                            }
                            
                            return cell
                        }
                    break
                
                default: //TEXT
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTextTblCell_ipad") as? TimeLineUpdateTextTblCell_ipad {
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        return cell
                    }
                }
                
                
            } else {
                
                switch dict.valueForInt(key: "mediaType") {
                case 1,3: // Image
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell") as? TimeLineUpdateTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                        
                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            cell.pageControlSlider.numberOfPages = arrImages.count
                            cell.loadSliderImages(images: arrImages, isGif: dict.valueForInt(key: "mediaType") == 3)
                        }
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        return cell
                    }
                    
                case 2: // VIDEO
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineUpdateVideoTblCell") as? TimelineUpdateVideoTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        cell.btnPlay.touchUpInside { (action) in
                            if let arrVideos = dict.valueForJSON(key: "media") as? [String] {
                                if arrVideos.count > 0{
                                    let videoURL = URL(string: arrVideos.first!)
                                    let player = AVPlayer(url: videoURL!)
                                    let playerViewController = AVPlayerViewController()
                                    playerViewController.player = player
                                    self.present(playerViewController, animated: true) {
                                        playerViewController.player!.play()
                                    }
                                }
                            }
                        }
                        return cell
                    }
                    
                    case 4: //URL
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateUrlTblCell") as? TimeLineUpdateUrlTblCell {
                            
                            cell.lblDesc.text = dict.valueForString(key: "description")
                            cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                            cell.lblUrl.text = dict.valueForString(key: "link")
                            
                            if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                                cell.loadSliderImages(images: arrImages)
                            }
                            
                            cell.btnShare.touchUpInside { (sender) in
                                self.shareContent()
                            }
                            
                            return cell
                    }
                default: //TEXT
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTextTblCell") as? TimeLineUpdateTextTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = dict.valueForString(key: "updatedAt")
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent()
                        }
                        
                        return cell
                    }

                }
            }
        }
        
        return UITableViewCell()
    }
    
}


//MARK:-
//MARK:- ------- API Functions

extension TimelineDetailViewController {
    
    @objc func pullToRefresh() {
        refreshControl?.beginRefreshing()
        self.loadSubscribedProjectList(isRefresh: true)
    }
    
    func loadSubscribedProjectList(isRefresh : Bool) {
        if self.apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            self.activityLoader.startAnimating()
            if !IS_iPad
            {
                self.btnProjectDetail.isHidden = true
            }
            
        }
        
        apiTask =  APIRequest.shared().getSubscribedProjectList { (response, error) in
            self.apiTask?.cancel()
            self.refreshControl?.endRefreshing()
            self.activityLoader.stopAnimating()
            
            if  response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                
                if arrData.count > 0 {
                    for item in arrData {
                        self.arrProject.append(item)
                    }
                }
                
                if !IS_iPad
                {
                    self.btnProjectDetail.isHidden = !(self.arrProject.count > 0)
                }
                
                
                self.tblUpdates.reloadData()
                
                self.pageIndexForApi = 1
                self.loadTimeLineListFromServer(true)
            }
        }
    }
    
    func loadTimeLineListFromServer(_ shouldShowLoader : Bool?){
        
        if self.apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        
        
        if arrProject.count - 1 >= currentIndex{
            let dic = arrProject[currentIndex]
            apiTask = APIRequest.shared().fetchTimelineList(dic.valueForInt(key: CProjectId), startDate: nil, endDate: nil, page : pageIndexForApi,shouldShowLoader : shouldShowLoader) { (response, error) in
                self.apiTask?.cancel()
                
                if response != nil{
                    if let arrData = response![CJsonData] as? [[String : Any]]{
                        if arrData.count > 0{
                            self.pageIndexForApi += 1
                            self.arrUpdateList = self.arrUpdateList + arrData
                            self.tblUpdates.reloadSections(IndexSet(integersIn: 1...1), with: .none)
                        }
                    }
                }
            }
        }
        
    }
}


//MARK:-
//MARK:- -------- Action Event

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
