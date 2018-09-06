//
//  TimeLineUpdateTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateTblCell: UITableViewCell {

    @IBOutlet weak var collImg : UICollectionView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var pageControlSlider : UIPageControl!

    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

extension TimeLineUpdateTblCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let index = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        pageControlSlider.currentPage = Int(index)

    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
//        pageControlSlider.currentPage = Int(page)
//    }
}
