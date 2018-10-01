//
//  VideoCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 27/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit

class VideoCollCell: UICollectionViewCell {

    @IBOutlet var imgThumbnail : UIImageView!
    @IBOutlet var btnPlay : UIButton!
    @IBOutlet var vwPlayer : UIView!
    var player = AVPlayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func layoutSubviews() {
//        if player.rate == 0 {
//            player.pause()
//        }
//    }

}
