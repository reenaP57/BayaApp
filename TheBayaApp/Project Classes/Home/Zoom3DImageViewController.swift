//
//  Zoom3DImageViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 20/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CTPanoramaView

class Zoom3DImageViewController: ParentViewController {

   @IBOutlet fileprivate weak var vwPanorama: CTPanoramaView!

    var imgUrl = ""
    
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
        
        //...Load 3D image
       
        GCDBackgroundThread.async {
            if let url = URL(string: self.imgUrl){
                do {
                    let imageData = try Data(contentsOf: url as URL)
                    let img = UIImage(data: imageData)
                    self.vwPanorama.image = img
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
        }
    }
}


//MARK:-
//MARK:- Action

extension Zoom3DImageViewController {
    
    @IBAction fileprivate func btnCloseClicked (sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

