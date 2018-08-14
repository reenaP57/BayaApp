//
//  SupportViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SupportViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtVMsg : UITextView!
    @IBOutlet fileprivate weak var imgVUpload : UIImageView!

    var imgData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Support"
    }
}


//MARK:-
//MARK:- Action

extension SupportViewController {
    
    @IBAction func btnSendClicked (sender : UIButton) {
        
    }
    
    @IBAction func btnUploadImage (sender : UIButton) {
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            
            if let selectedImage = image {
                imgVUpload.contentMode = .scaleToFill
                imgVUpload.image = selectedImage
                self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
            }
        }
    }
}
