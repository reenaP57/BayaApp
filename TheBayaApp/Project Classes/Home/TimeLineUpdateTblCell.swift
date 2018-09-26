//
//  TimeLineUpdateTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import BFRImageViewer
//import SwiftGifOrigin

class TimeLineUpdateTblCell: UITableViewCell {

    @IBOutlet weak var collImg : UICollectionView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var pageControlSlider : UIPageControl!

    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadSliderImages(images : [String]) {
        
        arrImg = images
        self.collImg.reloadData()
        GCDMainThread.async {
            self.collImg.reloadData()
        }
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
            cell.imgVSlider.sd_setShowActivityIndicatorView(true)
            cell.imgVSlider.sd_setImage(with: URL(string: arrImg[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TimeLineImgCollCell
        
        if cell.imgVSlider.image != nil
        {
            self.zoomImage()
        }
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
    
    func zoomImage(){
        if let zoomView = ImageZoomView.initImageZoomView() {
            appDelegate.window.addSubview(zoomView)
            zoomView.showImage(arrImg)
            zoomView.CViewSetY(y: CScreenHeight)
            UIView.animate(withDuration: 0.3) {
                zoomView.CViewSetY(y: 0)
            }
        }
    }
}
