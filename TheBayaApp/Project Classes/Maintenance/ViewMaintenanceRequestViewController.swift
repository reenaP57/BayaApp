//
//  ViewMaintenanceRequestViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVKit

class ViewMaintenanceRequestViewController: ParentViewController {

    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var lblSubject : UILabel!
    @IBOutlet weak var lblRequesetedDate : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var vwImg : UIView!
    @IBOutlet weak var vwStatus : UIView!
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var imgVMedia : UIImageView!
    @IBOutlet weak var vwContent : UIView!

    var barButton: UIBarButtonItem!
    var isFromRate : Bool = false
    var requestID : Int = 0
    var urlMedia = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if isFromRate {
             //...If user come from rate screen that time it will be redirect on maintenance list screen
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
        }
    }

    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "View Maintenance Request"
        self.loadViewMaintenanceRequestFromServer()
    }
    
    @objc func btnBackClicked() {
        
        for vwController in (self.navigationController?.viewControllers)! {
            
            if vwController.isKind(of: MaintenanceViewController.classForCoder()){
                
                if let maintenanceVC = vwController as? MaintenanceViewController {
                    maintenanceVC.currentPage = 1
                    maintenanceVC.loadMaintenanceRequestList(showLoader: false)
                    self.navigationController?.popToViewController(maintenanceVC, animated: true)
                }
                break
            }
        }
    }
}

//MARK:-
//MARK:- Action

extension ViewMaintenanceRequestViewController {
    
    @IBAction func btnPlayVideoClicked(_ sender : UIButton) {
       
        let videoURL = URL(string: urlMedia)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

//MARK:-
//MARK:- API Method

extension ViewMaintenanceRequestViewController {
    
    func loadViewMaintenanceRequestFromServer() {
        
        APIRequest.shared().loadViewMaintenanceRequest(maintenanceID: requestID) { (response, error) in
            
            if response != nil {
                
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {

                    self.vwContent.isHidden = false
                    self.lblSubject.text = responseData.valueForString(key: "subject")
                    self.lblType.text = responseData.valueForString(key: "maintenanceType")
                    self.lblRequesetedDate.text = "Requested on: \(DateFormatter.dateStringFrom(timestamp: responseData.valueForDouble(key: "createdAt")!, withFormate: "dd MMM yyyy"))"
                    self.lblDesc.text = responseData.valueForString(key: "message")
                    self.urlMedia =  responseData.valueForString(key: "mediaFile")
                    
                    if self.urlMedia != "" {
                        
                        if responseData.valueForInt(key: "mediaType") == 1 {
                            //...Image
                            self.btnPlay.isHidden = true
                            self.imgVMedia.sd_setShowActivityIndicatorView(true)
                            self.imgVMedia.sd_setImage(with: URL(string: self.urlMedia), placeholderImage: nil)
                            
                        } else {
                            //...Video
                            
                            //...Get thumbnail image from video url
                            DispatchQueue.global().async {
                                let videoURL = URL(string: self.urlMedia)
                                let asset = AVAsset(url: videoURL!)
                                let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                                assetImgGenerate.appliesPreferredTrackTransform = true
                                let time = CMTimeMake(1, 2)
                                let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                                if img != nil {
                                    let frameImg  = UIImage(cgImage: img!)
                                    DispatchQueue.main.async(execute: {
                                        if self.imgVMedia != nil {
                                            self.imgVMedia.image = frameImg
                                            self.btnPlay.isHidden = false
                                        }
                                    })
                                }
                            }
                        }
                    }
       
                    
                    switch responseData.valueForInt(key: "requestStatus") {
                    case CRequestOpen : //...Open
                        self.vwStatus.backgroundColor = ColorParrotColor
                        self.lblStatus.text = CDocRequestOpen
                    case CRequestCompleted : //...Completed
                        self.vwStatus.backgroundColor = ColorGreenSelected
                        self.lblStatus.text = CDocRequestCompleted
                    case CRequestInProgress : //...In Progress
                        self.vwStatus.backgroundColor = ColorOrange
                        self.lblStatus.text = CDocRequestInProgress
                    default :
                        break
                    }
                }
            }
        }
    }
}
