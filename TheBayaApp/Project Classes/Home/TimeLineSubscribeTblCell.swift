//
//  TimeLineSubscribeTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

let TRANSFORM_CELL_VALUE = CGAffineTransform(scaleX: 0.9, y: 0.9)
let ANIMATION_SPEED = 0.2

@objc protocol subscribeProjectListDelegate : class {
    func reloadTimelineList(index : Int)
}

class TimeLineSubscribeTblCell: UITableViewCell {

    @IBOutlet weak var collSubscribe : UICollectionView!
    var arrProject = [[String : AnyObject]]()
    var delegate : subscribeProjectListDelegate?
    var currentIndex = 0
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func loadProjectList(arr : [[String : AnyObject]], selectedIndex : Int){
        arrProject = arr
        currentIndex = selectedIndex
        collSubscribe.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
    }
    
    func CropImage(image:UIImage , cropRect:CGRect) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0);
        let context = UIGraphicsGetCurrentContext();
        
        context?.translateBy(x: 0.0, y: image.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.draw(image.cgImage!, in: CGRect(x:0, y:image.size.height - cropRect.height, width:image.size.width, height:image.size.height), byTiling: false);
        context?.clip(to: [cropRect]);
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return croppedImage!
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
            
            let dict = arrProject[indexPath.row]
            
            cell.lblProjectName.text = dict.valueForString(key: "project_name")
            cell.lblPercentage.text = " \(dict.valueForString(key: "percentage"))% "
            
            cell.btnSubscribe.touchUpInside { (sender) in
                cell.btnSubscribe.isSelected = !cell.btnSubscribe.isSelected
            }
            
            cell.btnCall.touchUpInside { (sender) in
                self.viewController?.dialPhoneNumber(phoneNumber: "123456789")
            }
            
            if IS_iPad {
                
                cell.btnScheduleVisit.touchUpInside { (sender) in
                    if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
                        self.viewController?.navigationController?.pushViewController(scheduleVisitVC, animated: true)
                    }
                }
                
                cell.btnProjectDetail.touchUpInside { (sender) in
                    
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        self.viewController?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                }
            }
            
            let space = IS_iPad ? 37 :30
            
            let imgVHeight = cell.imgVPjctCompletion.CViewHeight - CGFloat(space)
            
            let percentage = imgVHeight * CGFloat((dict.valueForInt(key: "percentage"))!)/100
            
            if (dict.valueForInt(key: "percentage")) != 100 {
                cell.imgVPjctCompletion.image = self.CropImage(image: cell.imgVPjctCompletion.image!, cropRect: CGRect(x: 0, y: imgVHeight - percentage , width: cell.imgVPjctCompletion.CViewWidth, height: percentage))
            }
            
            
            cell.cnstImgvDottedBottom.constant = -percentage+2
            cell.cnstlblPercentageCenter.constant = cell.imgVDottedLine.CViewCenterY
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let index = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        if currentIndex != Int(index) || currentIndex == 0 {
            currentIndex = Int(index)
            delegate?.reloadTimelineList(index: Int(index))
        }
        
        print("Index : ",Int(index))
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
        scrollView.setContentOffset(CGPoint(x: (CScreenWidth - pageWidth) +  CGFloat(index) * CScreenWidth, y: 0), animated: true)

        selectedIndexPath = IndexPath(item: index, section: 0)
        collSubscribe.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        
    }
}
