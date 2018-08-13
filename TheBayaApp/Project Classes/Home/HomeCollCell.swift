//
//  HomeCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class HomeCollCell: UICollectionViewCell {
    
    @IBOutlet weak var lblBadge : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblPrjctName : UILabel!
    @IBOutlet weak var imgVTitle : UIImageView!
    @IBOutlet weak var progressVCom : UIProgressView!
    @IBOutlet weak var lblPercentage : UILabel!
    @IBOutlet weak var vwProgress : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblBadge.layer.cornerRadius = lblBadge.CViewHeight/2
        lblBadge.layer.masksToBounds = true
        
        self.setupProgressView()
    }
    
    func setupProgressView() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ColorProgressGradient1.cgColor,ColorProgressGradient2.cgColor]
        gradientLayer.frame = progressVCom.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        progressVCom.progressImage = image?.resizableImage(withCapInsets: .zero)
    }
}
