//
//  TimeLineSubscribeTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 21/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineSubscribeTblCell: UITableViewCell {

    @IBOutlet weak var collSubscribe : UICollectionView!
    var arrProject = [[String : AnyObject]]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
             arrProject = [["project_name": "The Baya Victoria Chembur", "percentage": 100],["project_name": "The Baya Victoria Chembur", "percentage": 70],["project_name": "The Baya Victoria Chembur", "percentage": 35]] as [[String : AnyObject]]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        
        return IS_iPad ? CGSize(width: CScreenWidth * 450/768 , height: collectionView.CViewHeight) : CGSize(width: CScreenWidth - space , height: collectionView.CViewHeight)
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
            
            
            let imgVHeight = cell.imgVPjctCompletion.CViewHeight - 30
            
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
}
