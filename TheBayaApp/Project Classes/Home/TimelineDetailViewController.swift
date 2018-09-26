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
    @IBOutlet fileprivate weak var btnScheduleVisit : UIButton!
    @IBOutlet fileprivate weak var vwNoProject : UIView!
    @IBOutlet fileprivate weak var lblNoUpdates : UILabel!

    var arrUpdateList = [[String : Any]]()
    var arrProject = [[String : AnyObject]]()
    var currentIndex = 0
    var pageIndexForApi = 1
    var startDate = ""
    var endDate = ""
    
    var strFilterStartDate = ""
    var strFilterEndDate = ""
    var projectID = 0
    var isFromNotifition = false
    var isFromZoomImg = false
    
    var apiTask : URLSessionTask?
    var refreshControl : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CTimelineScreenName)
        
        if !isFromZoomImg {
            self.loadSubscribedProjectList(isRefresh: false, isFromNotification: isFromNotifition)
        }
        
        appDelegate.loginUser?.projectBadge = 0
        CoreData.saveContext()
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
       // self.loadSubscribedProjectList(isRefresh: false)
        
        if IS_iPad {
            tblUpdates.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        }
    }
    

    
    func shareContent(text : String, mediaUrl : String) {
        
        let shareAll = [text, mediaUrl]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showTimelineGuideLineView() {
       
        if CUserDefaults.string(forKey: UserDefaultOpenedTimeLine) != "true"
        {
            //... For TimeLine Guide Screen
            
            if let vwTimlineGuideline = TimelineGuideLineView.viewFromNib(is_ipad: IS_iPad) as? TimelineGuideLineView {
                
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
    
    func getDateTimeFromTimestamp(from interval : TimeInterval) -> String
    {
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) {
            return "Yesterday at \(DateFormatter.dateStringFrom(timestamp: interval, withFormate: "hh:mm a"))"
        } else if calendar.isDateInToday(date) {
            return "Today at \(DateFormatter.dateStringFrom(timestamp: interval, withFormate: "hh:mm a"))"
        } else {
            return DateFormatter.dateStringFrom(timestamp: interval, withFormate: "dd MMMM yyyy 'at' hh:mm a")
        }
    }
    
    func hideScheduleVisit() {
        
        let dict = arrProject[currentIndex]
        if dict.valueForInt(key: CIsVisit) == 0 {
            btnScheduleVisit.isHidden = true
            _ = btnProjectDetail.setConstraintConstant(-(btnScheduleVisit.CViewWidth/2), edge: .leading, ancestor: true)
            _ = btnProjectDetail.setConstraintConstant(btnScheduleVisit.CViewWidth/2, edge: .trailing, ancestor: true)
        } else {
            btnScheduleVisit.isHidden = false
            _ = btnProjectDetail.setConstraintConstant(20, edge: .leading, ancestor: true)
            _ = btnProjectDetail.setConstraintConstant(16, edge: .trailing, ancestor: true)
        }
    }
}



//MARK:-
//MARK:-

extension TimelineDetailViewController : subscribeProjectListDelegate {
   
    func reloadTimelineList(index: Int) {
        currentIndex = index
        pageIndexForApi = 1
        
        if IS_iPhone {
            self.hideScheduleVisit()
        }
        
        self.startDate = ""
        self.endDate = ""
        
        self.strFilterStartDate = ""
        self.strFilterEndDate = ""
        
        arrUpdateList.removeAll()
        self.tblUpdates.reloadSections(IndexSet(integersIn: 1...1), with: .none)


        self.loadTimeLineListFromServer(true, startDate: strFilterStartDate, endDate: strFilterEndDate)
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
                    cell.cnClSubscribeHeight.constant = IS_iPad ? CScreenWidth * (340/768) : CScreenWidth * (200/375)
                    
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
                        self.loadTimeLineListFromServer(false, startDate: strFilterStartDate, endDate: strFilterEndDate)
                    }
                }
            }
            
            let dict = arrUpdateList[indexPath.row]
            let mediaType = dict.valueForInt(key: "mediaType")
            if IS_iPad {
                
                switch mediaType {
                case 1,3: // Image
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell_ipad") as? TimeLineUpdateTblCell_ipad {
                        cell.updateImageViewSize()
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                        
                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            if arrImages.count > 0{
                                cell.loadSliderImagesIpad(images: arrImages, isGif: mediaType == 1 ? false : true)
                            }
                        }
                        
                        cell.btnShare.touchUpInside { (sender) in
                            if let arr = dict.valueForJSON(key: "media") as? [String] {
                                self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: arr.first!)
                            }
                        }
                        
                        return cell
                    }
                    
                case 2: // ViDEO
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineUpdateVideoTblCell") as? TimelineUpdateVideoTblCell {
                        cell.updateImageViewSize()
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)


                        cell.btnShare.touchUpInside { (sender) in
                            
                            let arrVideos = dict.valueForJSON(key: "media") as? [String]
                            self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: arrVideos?.count != 0 ? (arrVideos?.first)! : "")
                        }
                        
                        if let arrVideos = dict.valueForJSON(key: "media") as? [String] {
                            if arrVideos.count > 0{
                                DispatchQueue.global().async {
                                    let videoURL = URL(string: arrVideos.first!)
                                    let asset = AVAsset(url: videoURL!)
                                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                                    assetImgGenerate.appliesPreferredTrackTransform = true
                                    let time = CMTimeMake(1, 2)
                                    let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                                    if img != nil {
                                        let frameImg  = UIImage(cgImage: img!)
                                        DispatchQueue.main.async(execute: {
                                            if cell.imgVThumbNail != nil
                                            {
                                                cell.imgVThumbNail.image = frameImg
                                            }
                                        })
                                    }
                                }
                            }
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
                        
                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            if arrImages.count > 0{
                                if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateUrlTblCell_ipad") as? TimeLineUpdateUrlTblCell_ipad {
                                    cell.updateImageViewSize()
                                    
                                    cell.lblDesc.text = dict.valueForString(key: "description")
                                    cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                                    cell.lblUrl.text = dict.valueForString(key: "link")
                                    
                                    if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                                        
                                        if arrImages.count > 0{
                                            cell.imgVUpdate.sd_setShowActivityIndicatorView(true)
                                            cell.imgVUpdate.sd_setImage(with: URL(string: arrImages.first!), placeholderImage: nil, options: .retryFailed, completed: nil)
                                        }
                                    }
                                    
                                    // Hide Image Title here....
                                    cell.lblImgTitle.text = ""
                                    _ = cell.lblImgTitle.setConstraintConstant(0, edge: .top, ancestor: true)
                                    if let strMetaDiscription = dict.valueForJSON(key: "metaTitle") as? String{
                                        if !strMetaDiscription.isBlank{
                                            cell.lblImgTitle.text = strMetaDiscription
                                            _ = cell.lblImgTitle.setConstraintConstant(8, edge: .top, ancestor: true)
                                        }
                                    }


                                    // Hide Image Description here....
                                    cell.lblImgDescription.text = ""
                                    _ = cell.lblImgDescription.setConstraintConstant(0, edge: .top, ancestor: true)
                                    if let strMetaDiscription = dict.valueForJSON(key: "metaDescription") as? String{
                                        if !strMetaDiscription.isBlank{
                                            cell.lblImgDescription.text = strMetaDiscription
                                            _ = cell.lblImgDescription.setConstraintConstant(8, edge: .top, ancestor: true)
                                        }
                                    }
                                    
                                    
                                    cell.btnShare.touchUpInside { (sender) in
                                        self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: dict.valueForString(key: "link"))
                                    }
                                    
                                    cell.btnLinkContent.touchUpInside { (sender) in
                                        self.openInSafari(strUrl: dict.valueForString(key: "link"))
                                    }
                                    
                                    return cell
                                }
                            }else{
                                if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateUrlWithoutImageTblCell_ipad") as? TimeLineUpdateUrlWithoutImageTblCell_ipad {
                                    cell.lblDesc.text = dict.valueForString(key: "description")
                                    cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                                    cell.lblUrl.text = dict.valueForString(key: "link")
                                    
                                    // Hide Image Title here....
                                    cell.lblImgTitle.text = ""
                                    _ = cell.lblImgTitle.setConstraintConstant(0, edge: .top, ancestor: true)
                                    if let strMetaDiscription = dict.valueForJSON(key: "metaTitle") as? String{
                                        if !strMetaDiscription.isBlank{
                                            cell.lblImgTitle.text = strMetaDiscription
                                            _ = cell.lblImgTitle.setConstraintConstant(8, edge: .top, ancestor: true)
                                        }
                                    }
                                    
                                    
                                    // Hide Image Description here....
                                    cell.lblImgDescription.text = ""
                                    _ = cell.lblImgDescription.setConstraintConstant(0, edge: .top, ancestor: true)
                                    if let strMetaDiscription = dict.valueForJSON(key: "metaDescription") as? String{
                                        if !strMetaDiscription.isBlank{
                                            cell.lblImgDescription.text = strMetaDiscription
                                            _ = cell.lblImgDescription.setConstraintConstant(8, edge: .top, ancestor: true)
                                        }
                                    }
                                    
                                    
                                    cell.btnShare.touchUpInside { (sender) in
                                        self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: dict.valueForString(key: "link"))
                                    }
                                    
                                    cell.btnLinkContent.touchUpInside { (sender) in
                                        self.openInSafari(strUrl: dict.valueForString(key: "link"))
                                    }
                                    return cell
                                }
                            }
                        }
                    break
                
                default: //TEXT
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTextTblCell_ipad") as? TimeLineUpdateTextTblCell_ipad {
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                            
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: "")
                        }
                        
                        return cell
                    }
                }
                
                
            } else {
                
                switch dict.valueForInt(key: "mediaType") {
                case 1: // Image
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTblCell") as? TimeLineUpdateTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                        
                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            cell.pageControlSlider.numberOfPages = arrImages.count
                            cell.loadSliderImages(images: arrImages)
                        }
                        
                        cell.btnShare.touchUpInside { (sender) in
                            
                            if let arr = dict.valueForJSON(key: "media") as? [String] {
                                if arr.count > 0{
                                    self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: arr.first!)
                                }
                            }
                        }
                        
                        return cell
                    }
                    
                case 2: // VIDEO
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineUpdateVideoTblCell") as? TimelineUpdateVideoTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                        
                        cell.btnShare.touchUpInside { (sender) in
                            
                            let arrVideos = dict.valueForJSON(key: "media") as? [String]
                            self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: arrVideos?.count != 0 ? (arrVideos?.first)! : "")
                        }
                 
                        if let arrVideos = dict.valueForJSON(key: "media") as? [String] {
                            if arrVideos.count > 0{
                                DispatchQueue.global().async {
                                    let videoURL = URL(string: arrVideos.first!)
                                    let asset = AVAsset(url: videoURL!)
                                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                                    assetImgGenerate.appliesPreferredTrackTransform = true
                                    let time = CMTimeMake(1, 2)
                                    let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                                    if img != nil {
                                        let frameImg  = UIImage(cgImage: img!)
                                        DispatchQueue.main.async(execute: {
                                            cell.imgVThumbNail.image = frameImg
                                        })
                                    }
                                }
                            }
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
                    
                case 3: // GIF Image
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateGIFTblCell") as? TimeLineUpdateGIFTblCell {
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                        
                        if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                            if arrImages.count > 0{
                                cell.loadGifImage(arrImages.first!)
                            }
                        }
                        
                        cell.btnShare.touchUpInside { (sender) in
                            if let arr = dict.valueForJSON(key: "media") as? [String] {
                                self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: arr.first!)
                            }
                        }
                        
                        return cell
                    }
                    
                    case 4: //URL
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateUrlTblCell") as? TimeLineUpdateUrlTblCell {
                            
                            cell.lblDesc.text = dict.valueForString(key: "description")
                            cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                            cell.lblUrl.text = dict.valueForString(key: "link")

                            cell.collImg.hide(byHeight: false)
                            if let arrImages = dict.valueForJSON(key: "media") as? [String] {
                                if arrImages.count == 0 {
                                    cell.collImg.hide(byHeight: true)
                                }else{
                                    cell.loadSliderImages(images: arrImages)
                                }
                                
                            }

                            // Hide Image Title here....
                            cell.lblImgTitle.text = ""
                            _ = cell.lblImgTitle.setConstraintConstant(0, edge: .top, ancestor: true)
                            if let strMetaDiscription = dict.valueForJSON(key: "metaTitle") as? String{
                                if !strMetaDiscription.isBlank{
                                    cell.lblImgTitle.text = strMetaDiscription
                                    _ = cell.lblImgTitle.setConstraintConstant(8, edge: .top, ancestor: true)
                                }
                            }

                            
                            // Hide Image Description here....
                            cell.lblImgDescription.text = ""
                            _ = cell.lblImgDescription.setConstraintConstant(0, edge: .top, ancestor: true)
                            if let strMetaDiscription = dict.valueForJSON(key: "metaDescription") as? String{
                                if !strMetaDiscription.isBlank{
                                    cell.lblImgDescription.text = strMetaDiscription
                                    _ = cell.lblImgDescription.setConstraintConstant(8, edge: .top, ancestor: true)
                                }
                            }
                            
                            cell.btnShare.touchUpInside { (sender) in
                                self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: dict.valueForString(key: "link"))
                            }
                     
                            cell.btnLinkContent.touchUpInside { (sender) in
                                self.openInSafari(strUrl: dict.valueForString(key: "link"))
                            }
                            
                            return cell
                    }
                default: //TEXT
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineUpdateTextTblCell") as? TimeLineUpdateTextTblCell {
                        
                        cell.lblDesc.text = dict.valueForString(key: "description")
                        cell.lblDateTime.text =  self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "updatedAt")!)
                        
                        
                        cell.btnShare.touchUpInside { (sender) in
                            self.shareContent(text: dict.valueForString(key: "description"), mediaUrl: "")
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
        self.loadSubscribedProjectList(isRefresh: true, isFromNotification: isFromNotifition)
    }
    
    func loadSubscribedProjectList(isRefresh : Bool, isFromNotification : Bool) {
        if self.apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            self.activityLoader.startAnimating()
            if !IS_iPad
            {
                self.btnProjectDetail.isHidden = true
                self.btnScheduleVisit.isHidden = true
            }
            
        }
        
        vwNoProject.isHidden = true
        self.lblNoUpdates.isHidden = true
        
        apiTask =  APIRequest.shared().getSubscribedProjectList { (response, error) in
            self.apiTask?.cancel()
            self.refreshControl?.endRefreshing()
            self.activityLoader.stopAnimating()
            
            if  response != nil && error == nil {
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]]{
                    
                    self.arrProject = arrData
                    
                    if !IS_iPad {
                        self.btnProjectDetail.isHidden = !(self.arrProject.count > 0)
                        self.btnScheduleVisit.isHidden = !(self.arrProject.count > 0)
                        
                        if self.arrProject.count > 0 {
                            self.hideScheduleVisit()
                        }
                    }
                    
                    if self.arrProject.count != 0 {
                        self.showTimelineGuideLineView()
                    }
                    
                    self.vwNoProject.isHidden = self.arrProject.count != 0
                    
                    GCDMainThread.async {
                        self.tblUpdates.reloadData()
                    }
                    
                    
                    
                    if isFromNotification {
                        if let index = self.arrProject.index(where: {$0["projectId"] as? Int == self.projectID}){
                            self.currentIndex = index
                            self.tblUpdates.reloadData()
                            self.reloadTimelineList(index: self.currentIndex)
                        }else{
                            self.pageIndexForApi = 1
                            self.loadTimeLineListFromServer(true, startDate: self.strFilterStartDate, endDate: self.strFilterEndDate)
                        }
                        
                    } else {
                        
                        self.pageIndexForApi = 1
                        self.loadTimeLineListFromServer(true, startDate: self.strFilterStartDate, endDate: self.strFilterEndDate)
                    }
                }
            }
        }
    }
    
    func loadTimeLineListFromServer(_ shouldShowLoader : Bool?, startDate : String?, endDate : String?){
        
        
        if self.apiTask?.state == URLSessionTask.State.running {
            apiTask?.cancel()
        }
        
        if arrProject.count - 1 >= currentIndex{
            let dic = arrProject[currentIndex]
            apiTask = APIRequest.shared().fetchTimelineList(dic.valueForInt(key: CProjectId), startDate: startDate, endDate: endDate, page : pageIndexForApi,shouldShowLoader : shouldShowLoader) { (response, error) in
                self.apiTask?.cancel()
                
                if response != nil{
                    
                    if self.pageIndexForApi == 1{
                        self.arrUpdateList.removeAll()
                        
                        if !self.isFromNotifition {
//                            self.tblUpdates.reloadSections(IndexSet(integersIn: 1...1), with: .none)
                            self.tblUpdates.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
                        }
                    }
                    
                    if let arrData = response![CJsonData] as? [[String : Any]]{
                        if arrData.count > 0{
                            self.pageIndexForApi += 1
                            self.arrUpdateList = self.arrUpdateList + arrData
                            self.lblNoUpdates.isHidden = true
//                            self.tblUpdates.reloadSections(IndexSet(integersIn: 1...1), with: .none)
                            self.tblUpdates.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
                        }else{
                            
                            if self.pageIndexForApi == 1 {
                                self.lblNoUpdates.isHidden = false
                            }
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
    
    @IBAction func btnVisitProjectClicked (sender : UIButton) {
        
        if let projectVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController {
            self.navigationController?.pushViewController(projectVC, animated: true)
        }
    }
    
    @IBAction func btnScheduleVisitClicked (sender : UIButton) {
        
        let dic = arrProject[currentIndex]

        if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
            scheduleVisitVC.projectId = dic.valueForInt(key: CProjectId)!
            scheduleVisitVC.projectName = dic.valueForString(key: CProjectName)
            self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
        }
    }
    
    @IBAction func btnProjectDetailClicked (sender : UIButton) {
        
        let dic = arrProject[currentIndex]

        if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
            projectDetailVC.projectID = dic.valueForInt(key: CProjectId)!
            self.navigationController?.pushViewController(projectDetailVC, animated: true)
        }
    }
    
    @objc func btnFilterClicked() {
        
        let vwFilter = FilterView.initFilterView()
        let vwAlert = CustomAlertView.initAlertView()
        
        if self.startDate != "" && self.endDate != "" {
            vwFilter.txtStartDate.text = self.startDate
            vwFilter.txtEndDate.text = self.endDate
        }
        
        
        if IS_iPad {
            vwFilter.vwContent.layer.cornerRadius = 30
        } else {
            vwFilter.vwContent.roundCorners([.topLeft, .topRight], radius: 30)
        }
        
        
        UIView.animate(withDuration: 0.2, animations: {
        }) { (completed) in
            
            if completed {
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.03, options: .curveEaseIn, animations: {
                    
                    vwFilter.vwContent.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
                    
                }, completion: { (completed) in
                    
                    if completed {
                        vwFilter.vwContent.transform = .identity
                    }
                })
            }
        }
        

        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
             appDelegate.window.addSubview(vwFilter)
        }, completion: nil)
        
        
        vwAlert.btnOk.touchUpInside { (sender) in
            vwAlert.removeFromSuperview()
        }
        
        vwFilter.btnDone.touchUpInside { (sender) in
            
            self.startDate = vwFilter.txtStartDate.text!
            self.endDate = vwFilter.txtEndDate.text!
            
            
            let dateFormat = DateFormatter()
            
            let startDate = dateFormat.date(fromString: vwFilter.txtStartDate.text!, dateFormat: "dd MMMM YYYY")
            let endDate = dateFormat.date(fromString: vwFilter.txtEndDate.text!, dateFormat: "dd MMMM YYYY")

            
            if (vwFilter.txtStartDate.text?.isBlank)!{
                
                vwAlert.lblMsg.text = CMessageStartDate
                UIView.animate(withDuration: 1.0) {
                    appDelegate.window.addSubview(vwAlert)
                }
            }else if (vwFilter.txtEndDate.text?.isBlank)!{
                
                vwAlert.lblMsg.text = CMessageEndDate
                UIView.animate(withDuration: 1.0) {
                    appDelegate.window.addSubview(vwAlert)
                }
            } else if startDate?.compare((endDate)!) == .orderedDescending {
                
                vwAlert.lblMsg.text = CMessageCompareFilterDate
                UIView.animate(withDuration: 1.0) {
                    appDelegate.window.addSubview(vwAlert)
                }
            } else {
                self.strFilterStartDate = "\(DateFormatter.shared().timestampFromDate(date: vwFilter.txtStartDate.text!, formate: "dd MMMM yyyy") ?? 0.0)"
                self.strFilterEndDate = "\(DateFormatter.shared().timestampFromDate(date: vwFilter.txtEndDate.text!, formate: "dd MMMM yyyy") ?? 0.0)"
                self.pageIndexForApi = 1
                self.loadTimeLineListFromServer(true, startDate: self.strFilterStartDate, endDate: self.strFilterEndDate)
                
                UIView.animate(withDuration: 0.3, animations: {
                }, completion: { (completed) in
                    if completed {
                        vwFilter.removeFromSuperview()
                    }
                })
               
            }
            
        }
        
        vwFilter.btnClose.touchUpInside { (sender) in
            
            UIView.animate(withDuration: 0.3, animations: {
            }, completion: { (completed) in
                if completed {
                    vwFilter.removeFromSuperview()
                }
            })
        }
        
        vwFilter.btnClear.touchUpInside { (sender) in
            vwFilter.txtStartDate.text = ""
            vwFilter.txtEndDate.text = ""
            self.strFilterStartDate = ""
            self.strFilterEndDate = ""
            self.pageIndexForApi = 1
            self.loadTimeLineListFromServer(true, startDate: self.strFilterStartDate, endDate: self.strFilterEndDate)
          
            UIView.animate(withDuration: 0.5, delay: 1.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                vwFilter.removeFromSuperview()
            }, completion: nil)
        }
    }
}
