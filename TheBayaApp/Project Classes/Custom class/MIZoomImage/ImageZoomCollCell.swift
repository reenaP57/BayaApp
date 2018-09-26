//
//  ImageZoomCollCell.swift
//  SocialMedia
//
//  Created by mac-0005 on 24/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ImageZoomCollCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var imgGallery : UIImageView!
    @IBOutlet var scrollView : UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(_:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGR)
    }
}

// MARK:- -------- UIScrollViewDelegate
extension ImageZoomCollCell{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgGallery
    }
}

// MARK:- -------- UIGestureRecognizer
extension ImageZoomCollCell{
    @objc fileprivate func doubleTapGesture(_ sender : UIGestureRecognizer) {
        if scrollView.zoomScale > 1.0{
            UIView.animate(withDuration: 0.3) {
                self.scrollView.zoomScale = 1.0
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.scrollView.zoomScale = 6.0
            }
        }
    }
}


