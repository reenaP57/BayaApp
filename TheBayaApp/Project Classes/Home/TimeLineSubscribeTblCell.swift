//
//  TimeLineSubscribeTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CoreTelephony

let TRANSFORM_CELL_VALUE = CGAffineTransform(scaleX: 0.9, y: 0.9)
let ANIMATION_SPEED = 0.2

@objc protocol subscribeProjectListDelegate : class {
    func reloadTimelineList(index : Int)
}

class TimeLineSubscribeTblCell: UITableViewCell {

    @IBOutlet weak var collSubscribe : UICollectionView!
    @IBOutlet weak var cnClSubscribeHeight : NSLayoutConstraint!
    
    var arrProject = [[String : AnyObject]]()
    var delegate : subscribeProjectListDelegate?
    var currentIndex = 0
    var favProjectIndexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadProjectList(arr : [[String : AnyObject]], selectedIndex : Int){
        arrProject = arr
        currentIndex = selectedIndex
//        arrProject.sort(by: {$1[CProjectId] as! Int > $0[CProjectId] as! Int})

        // To get Fav. project...
        if let index = arrProject.index(where: {$0[CIsFavorite] as? Int  == 1}){
            favProjectIndexPath = IndexPath(item: index, section: 0)
        }
        
        
        GCDMainThread.async {
            if self.currentIndex == 0{
                self.collSubscribe.setContentOffset(.zero, animated: false)
                self.collSubscribe.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: false)
            }else {
                self.collSubscribe.setContentOffset(CGPoint(x:CGFloat(self.currentIndex) * CScreenWidth, y: 0), animated: false)
                self.collSubscribe.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: false)
            }
        }

    }
    
    func CropImage(image:UIImage , cropRect:CGRect) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0);
        let context = UIGraphicsGetCurrentContext();
        
        context?.translateBy(x: 0.0, y: image.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.draw(image.cgImage!, in: CGRect(x:0, y:image.size.height - cropRect.height, width:image.size.width, height:image.size.height), byTiling: false);
        context?.clip(to: [cropRect]);
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return croppedImage
    }
}



//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimeLineSubscribeTblCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProject.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return IS_iPad ? CGSize(width: CScreenWidth * 500/768 , height: CScreenWidth * 290/768) : CGSize(width: CScreenWidth - space , height: collectionView.CViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscribedProjectCollCell", for: indexPath) as? SubscribedProjectCollCell {
            
            var dict = arrProject[indexPath.row]
            
            cell.lblProjectName.text = "\(dict.valueForString(key: CProjectName)),"
            cell.lblLocation.text = dict.valueForString(key: "shortLocation")
            cell.lblReraNo.text = dict.valueForString(key: CReraNumber)
            cell.lblPercentage.text = " \(dict.valueForInt(key: CProjectProgress) ?? 0)% "
            cell.vwSoldOut.isHidden = dict.valueForInt(key: CIsSoldOut) == 0 ?  true : false
            
//            cell.btnSubscribe.isSelected = dict.valueForInt(key: CIsFavorite) == 0 ? false : true
            cell.btnSubscribe.isSelected = indexPath == favProjectIndexPath
            
            cell.btnSubscribe.touchUpInside { (sender) in
                MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "TimeLine subscribe")
                var isFavType = 0
                if !cell.btnSubscribe.isSelected{
                    isFavType = 1
                }
                
                APIRequest.shared().favouriteSubcribedProject(dict.valueForInt(key: CProjectId), type: isFavType, completion: { (response, error) in
                    
                    if response != nil && error == nil {
                    
                        cell.btnSubscribe.isSelected = !cell.btnSubscribe.isSelected
                        
                        let data = response?.value(forKey: CJsonData) as! [String : AnyObject]
                        
                        // To get previous Fav. project...
                        if let index = self.arrProject.index(where: {$0[CIsFavorite] as? Int  == 1}){
                         var dicPreviousProject = self.arrProject[index]
                            dicPreviousProject[CIsFavorite] = 0 as AnyObject
                            self.arrProject[index] = dicPreviousProject
                            self.collSubscribe.reloadData()
                        }
                        
                        self.favProjectIndexPath = nil
                        if sender.isSelected{
                            dict[CIsFavorite] = data.valueForInt(key: CIsFavorite) as AnyObject
                            self.arrProject[indexPath.row] = dict
                            self.favProjectIndexPath = indexPath
                            self.collSubscribe.reloadData()
                            
                            if data.valueForInt(key: CIsFavorite) == 1{
                                appDelegate.loginUser?.project_name = dict.valueForString(key: CProjectName)
                                appDelegate.loginUser?.projectProgress = Int16(dict.valueForInt(key: CProjectProgress)!)
                            } else {
                                appDelegate.loginUser?.project_name = ""
                                appDelegate.loginUser?.projectProgress = 0
                            }
                            
                            CoreData.saveContext()
                        }
                        
                       
                    }
                })
            }
            
            cell.btnCall.touchUpInside { (sender) in
                
                MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "TimeLine Call")
                
                let arrMobileNo = dict.valueForJSON(key: "contactDetail") as! [[String : AnyObject]]
                
                if arrMobileNo.count > 0 {
                    self.viewController?.dialPhoneNumber(phoneNumber: arrMobileNo[0].valueForString(key: "mobileNo"))
                }
            }
            
            if IS_iPad {
                
                //...Check device support calling features
                
                if UIApplication.shared.canOpenURL(NSURL(string: "tel://")! as URL) {
                    if let mnc = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode, !mnc.isEmpty {
                    } else {
                        cell.btnCall.isHidden = true
                        _ = cell.btnProjectDetail.setConstraintConstant(60, edge: .trailing, ancestor: true)
                    }
                } else {
                    cell.btnCall.isHidden = true
                    _ = cell.btnProjectDetail.setConstraintConstant(60, edge: .trailing, ancestor: true)
                }
                
                
                //...Hide schedule visit button
                
                if dict.valueForInt(key: CIsVisit) == 0 {
                    cell.btnScheduleVisit.isHidden = true
                    _ = cell.btnProjectDetail.setConstraintConstant(cell.btnScheduleVisit.CViewWidth - 20/2, edge: .trailing, ancestor: true)
                } else {
                    cell.btnScheduleVisit.isHidden = false
                }
                
                
                cell.btnScheduleVisit.touchUpInside { (sender) in
                    
                     MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "TimeLine ScheduleVisit")
                    
                    cell.btnScheduleVisit.alpha = 0.8
                    GCDMainThread.asyncAfter(deadline: .now() + 0.08) {
                        cell.btnScheduleVisit.alpha = 1.0
                        if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
                            scheduleVisitVC.projectId = dict.valueForInt(key: CProjectId)!
                            scheduleVisitVC.projectName = dict.valueForString(key: CProjectName); self.viewController?.navigationController?.pushViewController(scheduleVisitVC, animated: true)
                        }
                    }
                }
                
                cell.btnProjectDetail.touchUpInside { (sender) in
                    MIGoogleAnalytics.shared().trackCustomEvent(buttonName: "TimeLine ProjectDetail")
                    
                    cell.btnProjectDetail.alpha = 0.8
                    GCDMainThread.asyncAfter(deadline: .now() + 0.08) {
                        cell.btnProjectDetail.alpha = 1.0
                        if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                            projectDetailVC.projectID = dict.valueForInt(key: CProjectId)!
                            self.viewController?.navigationController?.pushViewController(projectDetailVC, animated: true)
                        }
                    }
                    
          
                }
            }
            
            cell.imgVPjctCompletion.image =  IS_iPad ? UIImage(named: "project_completion_ipad") : UIImage(named: "project_completion")
            let space = IS_iPad ? 37 :30
            
            let imgVHeight = cell.imgVPjctCompletion.CViewHeight - CGFloat(space)
            
            let percentage = imgVHeight * CGFloat((dict.valueForInt(key: CProjectProgress))!)/100
            
            if (dict.valueForInt(key: CProjectProgress)) != 100 || (dict.valueForInt(key: CProjectProgress)) != 0 {
                if cell.imgVPjctCompletion.image != nil{
                    cell.imgVPjctCompletion.image = self.CropImage(image: cell.imgVPjctCompletion.image!, cropRect: CGRect(x: 0, y: imgVHeight - percentage , width: cell.imgVPjctCompletion.CViewWidth, height: percentage))
                }
            }
            
            if (dict.valueForInt(key: CProjectProgress)) == 0 {
                cell.cnstImgvDottedBottom.constant = -percentage+2
                cell.cnstlblPercentageCenter.constant = -percentage-cell.lblPercentage.CViewHeight/2 //cell.imgVProgress.CViewY + cell.imgVProgress.CViewHeight - cell.lblPercentage.CViewHeight/2

            } else {
                cell.cnstImgvDottedBottom.constant = -percentage+2
                cell.cnstlblPercentageCenter.constant = cell.imgVDottedLine.CViewCenterY
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = IS_iPad ? CScreenWidth * 500/768 : CScreenWidth - space
        
        let currentOffset = Float(scrollView.contentOffset.x)
        let targetOffset = Float(targetContentOffset.pointee.x)
        var newTargetOffset = Float(0)
        
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / Float(pageWidth)) * Float(pageWidth)
        } else {
            newTargetOffset = floorf(currentOffset / Float(pageWidth)) * Float(pageWidth)
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        
        _ = Float(targetContentOffset.pointee.x) == currentOffset
        let index : Int = Int(newTargetOffset / Float(pageWidth))
        
        if index <= 0{
            
            GCDMainThread.async {
                scrollView.setContentOffset(.zero, animated: true)
                self.collSubscribe.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
            }
            
        }else {
            if index <= arrProject.count - 1{
                GCDMainThread.async {
                    scrollView.setContentOffset(CGPoint(x:CGFloat(index) * CScreenWidth, y: 0), animated: true)
                    self.collSubscribe.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
                }
            }
            
        }

        GCDMainThread.asyncAfter(deadline: .now() + 0.3) {
            if self.currentIndex != Int(index) && Int(index) >= 0 && index <= self.arrProject.count - 1{
                self.currentIndex = Int(index)
                self.delegate?.reloadTimelineList(index: Int(index))
            }
        }
    }
}
