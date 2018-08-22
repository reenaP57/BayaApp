//
//  TimeLineUpdateTblCell_ipad.swift
//  TheBayaApp
//
//  Created by mac-00017 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateTblCell_ipad: UITableViewCell {

    @IBOutlet weak var imgVUpdate : UIImageView!
    @IBOutlet weak var collImg : UICollectionView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!

    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVUpdate.layer.cornerRadius = 5
        imgVUpdate.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadSliderImages(images : [String]) {
        
        arrImg = images
        collImg.reloadData()
    }

}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimeLineUpdateTblCell_ipad : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count > 5 ? 5 : arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineImgCollCell", for: indexPath) as? TimeLineImgCollCell {
           
            if arrImg.count > 5 {
                cell.vwCount.isHidden = indexPath.item != 4
                cell.imgVSlider.isHidden = indexPath.item == 4
                cell.lblCount.text = "+\(arrImg.count - 5)"
            }
            
            cell.imgVSlider.image = UIImage(named: arrImg[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrImg.count > 5 && indexPath.item == 4 {
            
            if let zoomImgVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineImgZoomViewController_ipad") as? TimelineImgZoomViewController_ipad {
                zoomImgVC.arrImg = arrImg
                self.viewController?.navigationController?.present(zoomImgVC, animated: true, completion: nil)
            }
            
        }
    }
  
}
