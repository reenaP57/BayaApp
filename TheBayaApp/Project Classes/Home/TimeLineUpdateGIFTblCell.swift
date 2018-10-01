//
//  TimeLineUpdateGIFTblCell.swift
//  TheBayaApp
//
//  Created by mac-0005 on 25/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import SDWebImage

class TimeLineUpdateGIFTblCell: UITableViewCell {

    @IBOutlet weak var imgGif : FLAnimatedImageView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnZoomImg : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        SDWebImageCodersManager.sharedInstance().addCoder(SDWebImageGIFCoder.shared())
        
        GCDMainThread.async {
            self.imgGif.layer.cornerRadius = 5
            self.imgGif.layer.masksToBounds = true
        }
    }
    
    func loadGifImage(_ url : String?){
        imgGif.sd_setImage(with: URL(string: url!), completed: nil)
        imgGif.sd_cacheFLAnimatedImage = false
    }
}
