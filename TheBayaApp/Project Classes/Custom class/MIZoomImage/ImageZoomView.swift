//
//  ImageZoomView.swift
//  SocialMedia
//
//  Created by mac-0005 on 24/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ImageZoomView: UIView {
    
    @IBOutlet var clImage : UICollectionView!
    var arrImages = [String]()
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var pageController : UIPageControl!
    var imageIndex:Int = 0
    
    class func initImageZoomView() -> ImageZoomView?
    {
        let zoomView : ImageZoomView = Bundle.main.loadNibNamed("ImageZoomView", owner: nil, options: nil)?.last as! ImageZoomView
        zoomView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        return zoomView
    }
    
    func showImage(_ arr : [String]?){
        arrImages = arr!
        clImage.register(UINib(nibName: "ImageZoomCollCell", bundle: nil), forCellWithReuseIdentifier: "ImageZoomCollCell")
        
        GCDMainThread.async {
            self.pageController.numberOfPages = self.arrImages.count
            self.clImage.reloadData()
            self.imageIndex = 0
            self.clImage.setContentOffset(CGPoint(x: CScreenWidth * CGFloat(self.imageIndex), y: 0), animated: false)
            self.updatePageController()
            
        }
        
    }
}

// MARK:- --------- UICollectionView Delegate/Datasources
extension ImageZoomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:clImage.frame.size.width, height: clImage.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageZoomCollCell", for: indexPath) as! ImageZoomCollCell
        cell.scrollView.zoomScale = 1.0
        cell.imgGallery.sd_setShowActivityIndicatorView(true)
        cell.imgGallery.sd_setImage(with: URL(string: arrImages[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
        
        return cell
    }
}

// MARK:- ------- UIScrollView Delegate

extension ImageZoomView{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        imageIndex = Int(page < 1 ? 0 : page)
        self.updatePageController()
    }
}
// MARK:- ------- PageController
extension ImageZoomView{
    func updatePageController(){
        
        pageController.currentPage = imageIndex
    }
    
}

// MARK:- ------- Action event

extension ImageZoomView{
    @IBAction func btnCancelCLK(_ sender : UIButton){
        UIView.animate(withDuration: 0.3, animations: {
            self.CViewSetY(y: CScreenHeight)
        }) { (completed) in
            self.removeFromSuperview()
        }
    }
        
    @IBAction func btnImageBackNextCLK(_ sender : UIButton){
        
        switch sender.tag {
        case 0:
            // back CLK
            if imageIndex > 0{
                imageIndex = imageIndex-1;
            }
            break
        case 1:
            // Next CLK
            if imageIndex < arrImages.count - 1{
                imageIndex = imageIndex+1;
            }
            break
        default:
            break
        }
        clImage.setContentOffset(CGPoint(x: CScreenWidth * CGFloat(imageIndex), y: 0), animated: true)
        self.updatePageController()
    }
    
}
