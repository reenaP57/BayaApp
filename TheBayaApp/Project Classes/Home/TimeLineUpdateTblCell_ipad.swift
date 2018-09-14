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
    @IBOutlet weak var cnImgVUpdateHeight : NSLayoutConstraint!
    @IBOutlet weak var cnImgVUpdateWidth : NSLayoutConstraint!
    
    
    var isGifImages = false
    var arrImg = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVUpdate.layer.cornerRadius = 5
        imgVUpdate.layer.masksToBounds = true
    }
    
    
    func updateImageViewSize(){
        cnImgVUpdateWidth.constant = CScreenHeight*271/1144
        cnImgVUpdateHeight.constant = CScreenHeight*161/1144
    }
    
    func loadSliderImagesIpad(images : [String], isGif : Bool?) {
        isGifImages = isGif!
        
        if images.count > 1{
            arrImg = images
            arrImg.remove(at: 0)    // Remove first object...
            collImg.reloadData()
        }
        
    }

}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimeLineUpdateTblCell_ipad : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count > 4 ? 5 : arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: collImg.frame.size.height, height: collImg.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineImgCollCell", for: indexPath) as? TimeLineImgCollCell {
           
            if arrImg.count > 4 {
                if indexPath.item == 4{
                    cell.imgVSlider.isHidden = true
                    cell.vwCount.isHidden = false
                    cell.lblCount.text = "+\(arrImg.count - 4)"
                }else{
                    cell.imgVSlider.isHidden = false
                    cell.vwCount.isHidden = true
                }
            }else{
                cell.vwCount.isHidden = true
            }
            
            if indexPath.item != 4{
                if isGifImages{
                    cell.imgVSlider.image = UIImage.gif(url: URL(string: arrImg[indexPath.row])!)
                }else{
                    cell.imgVSlider.sd_setShowActivityIndicatorView(true)
                    cell.imgVSlider.sd_setImage(with: URL(string: arrImg[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
                }
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrImg.count > 4 && indexPath.item == 4 {
            
            if let zoomImgVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineImgZoomViewController_ipad") as? TimelineImgZoomViewController_ipad {
                zoomImgVC.arrImg = arrImg
                self.viewController?.navigationController?.present(zoomImgVC, animated: true, completion: nil)
            }
            
        }
    }
  
}
