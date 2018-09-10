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
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    
    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: arrImg.count > 1 ? (CScreenWidth - space) : (CScreenWidth - 30), height: collectionView.CViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineImgCollCell", for: indexPath) as? TimeLineImgCollCell {
            
            cell.imgVSlider.image = UIImage(named: arrImg[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }

}
