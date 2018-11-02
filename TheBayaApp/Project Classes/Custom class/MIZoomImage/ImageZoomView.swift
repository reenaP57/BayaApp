//
//  ImageZoomView.swift
//  SocialMedia
//
//  Created by mac-0005 on 24/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit

class ImageZoomView: UIView {
    
    @IBOutlet var clImage : UICollectionView!
    var arrImages = [String]()
    var arrImgVideo = [[String : AnyObject]]()
    
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var pageController : UIPageControl!
    var imageIndex:Int = 0
    
    class func initImageZoomView() -> ImageZoomView?
    {
        let zoomView : ImageZoomView = Bundle.main.loadNibNamed("ImageZoomView", owner: nil, options: nil)?.last as! ImageZoomView
        zoomView.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight)
        return zoomView
    }
    
    func showImageAndVideo(_ arr : [[String :AnyObject]]?, _ imgIndex : Int?){
        arrImgVideo = arr!
        clImage.register(UINib(nibName: "ImageZoomCollCell", bundle: nil), forCellWithReuseIdentifier: "ImageZoomCollCell")
        clImage.register(UINib(nibName: "VideoCollCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollCell")

        GCDMainThread.async {
            self.pageController.numberOfPages = self.arrImgVideo.count
            self.clImage.reloadData()
            self.imageIndex = imgIndex!  //0
            self.clImage.setContentOffset(CGPoint(x: CScreenWidth * CGFloat(self.imageIndex), y: 0), animated: false)
            self.updatePageController()
            
        }
    }
    
    func showImage(_ arr : [String]?, _ imgIndex : Int?){
        arrImages = arr!
        clImage.register(UINib(nibName: "ImageZoomCollCell", bundle: nil), forCellWithReuseIdentifier: "ImageZoomCollCell")
        
        GCDMainThread.async {
            self.pageController.numberOfPages = self.arrImages.count
            self.clImage.reloadData()
            self.imageIndex = imgIndex! //0
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
        
        return arrImgVideo.count > 0 ? arrImgVideo.count : arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:clImage.frame.size.width, height: clImage.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if arrImgVideo.count > 0 {
            
            let dict = arrImgVideo[indexPath.row]

            if dict.valueForInt(key: "type") == 1 {
                //...Image
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageZoomCollCell", for: indexPath) as! ImageZoomCollCell
                cell.scrollView.zoomScale = 1.0
                cell.imgGallery.sd_setShowActivityIndicatorView(true)
                cell.imgGallery.sd_setImage(with: URL(string: dict.valueForString(key: "url")), placeholderImage: nil, options: .retryFailed, completed: nil)

                return cell

            } else {
               //...Video
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollCell", for: indexPath) as! VideoCollCell
                
                DispatchQueue.global().async {
                    let videoURL = URL(string: dict.valueForString(key: "url"))
                    let asset = AVAsset(url: videoURL!)
                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    let time = CMTimeMake(1, 2)
                    let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                    if img != nil {
                        let frameImg  = UIImage(cgImage: img!)
                        DispatchQueue.main.async(execute: {
                            if cell.imgThumbnail != nil
                            {
                                cell.imgThumbnail.image = frameImg
                            }
                        })
                    }
                }
            
//                let url = URL(string: dict.valueForString(key: "url"))
//                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
//
//                cell.player = AVPlayer(playerItem: playerItem)
//
//                let playerLayer = AVPlayerLayer(player: cell.player)
//                playerLayer.frame = CGRect(x:0, y:0, width:CScreenWidth, height:CScreenHeight)
//                cell.vwPlayer.layer.addSublayer(playerLayer)
//
//                cell.btnPlay.touchUpInside { (sender) in
//                    if cell.btnPlay.isSelected {
//                        cell.btnPlay.isSelected = false
//                        cell.imgThumbnail.isHidden = false
//                        cell.player.pause()
//                    } else {
//                        cell.btnPlay.isSelected = true
//                        cell.imgThumbnail.isHidden = true
//                        cell.player.play()
//                    }
//                }
            
                
                cell.btnPlay.touchUpInside { (action) in
                    
                    if let videoUrl = dict.valueForString(key: "url") as? String {
                       
                        let videoURL = URL(string: videoUrl)
                        let player = AVPlayer(url: videoURL!)
                        let playerController = AVPlayerViewController()
                        playerController.player = player
                        self.topMostController()!.present(playerController, animated: true) {
                            player.play()
                        }
                    }
                }
            
                return cell
            }
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageZoomCollCell", for: indexPath) as! ImageZoomCollCell
            cell.scrollView.zoomScale = 1.0
            cell.imgGallery.sd_setShowActivityIndicatorView(true)
            cell.imgGallery.sd_setImage(with: URL(string: arrImages[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
            
            return cell
        }
    }
    
   /* func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if arrImgVideo.count > 0 {

            let dict = arrImgVideo[indexPath.row]

            if dict.valueForInt(key: "type") != 1 {

                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollCell", for: indexPath) as? VideoCollCell {
                    if cell.btnPlay.isSelected {
                        cell.player.pause()
                    }
                }
            }
        }
    } */
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
