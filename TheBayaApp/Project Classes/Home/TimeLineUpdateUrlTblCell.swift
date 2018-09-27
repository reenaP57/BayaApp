//
//  TimeLineUpdateUrlTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 07/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateUrlTblCell: UITableViewCell {
    
    
    @IBOutlet weak var collImg : UICollectionView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblImgTitle : UILabel!
    @IBOutlet weak var lblImgDescription : UILabel!
    @IBOutlet weak var viewContainer : UIView!
    
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnLinkContent : UIButton!
    
    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        GCDMainThread.async {
            self.viewContainer.layer.borderWidth = 1
            self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
            self.viewContainer.layer.cornerRadius = 7
        }
    }
    
    
    
    func loadSliderImages(images : [String]) {
        
        arrImg = images
        
        GCDMainThread.async {
            self.collImg.reloadData()
        }
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimeLineUpdateUrlTblCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize  {
        return CGSize(width: arrImg.count > 1 ? (collectionView.CViewWidth - space) : collectionView.CViewWidth, height: collectionView.CViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineImgCollCell", for: indexPath) as? TimeLineImgCollCell {
            cell.imgVSlider.sd_setImage(with: URL(string: arrImg[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
            return cell
        }
        
        return UICollectionViewCell()
    }

}
