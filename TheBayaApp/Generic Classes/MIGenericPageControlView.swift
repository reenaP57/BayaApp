//
//  MIGenericPageControlView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericPageControlView: UIPageControl {
    
    @IBInspectable var currentPageImage: UIImage?
    
    @IBInspectable var otherPagesImage: UIImage?
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
    }
    
    private func updateDots() {
        
        for (index, subview) in subviews.enumerated() {
            let imageView: UIImageView
            if let existingImageview = getImageView(forSubview: subview) {
                imageView = existingImageview
            } else {
                imageView = UIImageView(image: otherPagesImage)
                
                imageView.center = subview.center
                subview.addSubview(imageView)
                subview.clipsToBounds = false
            }
            imageView.image = currentPage == index ? currentPageImage : otherPagesImage
        }
    }
    
    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
                } as? UIImageView
            
            return view
        }
    }
}

