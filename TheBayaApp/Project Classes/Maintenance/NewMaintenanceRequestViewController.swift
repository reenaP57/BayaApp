//
//  NewMaintenanceRequestViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import AVFoundation

class NewMaintenanceRequestViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtSubject : UITextField!
    @IBOutlet fileprivate weak var txtMaintenanceType : UITextField!{
        didSet {
            txtMaintenanceType.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtVMsg : UITextView!
        {
        didSet {
            txtVMsg.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }
    
    @IBOutlet fileprivate weak var imgVPlay : UIImageView!
    @IBOutlet fileprivate weak var imgVUpload : UIImageView!
    @IBOutlet fileprivate weak var vwMsg : UIView!
    @IBOutlet fileprivate weak var vwContent : UIView!
    var imgData = Data()
    var maintenanceID : Int = 0
    var mediaType : Int = 0
    let cameraSession = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        self.title = "New Maintenance Request"
        
        txtMaintenanceType.setPickerData(arrPickerData: MIGeneralsAPI.shared().arrMaintenanceType.mapValue(forKey: "name") as! [Any], selectedPickerDataHandler: { (title, index, component) in
            self.maintenanceID = MIGeneralsAPI.shared().arrMaintenanceType[index].valueForInt(key: CId) ?? 0
            self.txtMaintenanceType.hideValidationMessage(15.0)
        }, defaultPlaceholder: "")
        
        GCDMainThread.async {
            self.vwMsg.layer.masksToBounds = true
            self.vwMsg.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            self.vwMsg.layer.shadowOpacity = 5
            self.vwMsg.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.vwMsg.layer.shadowRadius = 7
            self.vwMsg.layer.cornerRadius = 3
        }
    
    }
    
    func showValidation(isAdd : Bool){
        
        //...Set validation for purpose textView
        self.txtVMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
        
        if isAdd {
            //... show validation
            txtVMsg.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwMsg.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
            vwMsg.layer.borderWidth = 1.0
            vwMsg.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            
        } else {
            //...Hide validation
            txtVMsg.backgroundColor = UIColor.white
            vwMsg.backgroundColor = UIColor.white
            vwMsg.layer.borderWidth = 0.0
            vwMsg.layer.borderColor = UIColor.white.cgColor
            vwMsg.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        }
    }
}


//MARK:-
//MARK:- Action

extension NewMaintenanceRequestViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBAction func btnSubmitClicked (sender : UIButton) {
        
        if (self.txtMaintenanceType.text?.isBlank)! {
            
            self.txtSubject.hideValidationMessage(15.0)
            self.txtVMsg.textfiledAddRemoveShadow(true)
            self.showValidation(isAdd: false)
            _ = self.vwMsg.setConstraintConstant((30/2) + 30 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
            
            self.vwContent.addSubview(self.txtMaintenanceType.showValidationMessage(15.0, CSelectMaintenanceType))
            
        } else if (self.txtSubject.text?.isBlank)! {
            self.txtVMsg.textfiledAddRemoveShadow(true)
            self.showValidation(isAdd: false)
            _ = self.vwMsg.setConstraintConstant((30/2) + 30 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
            self.vwContent.addSubview(self.txtSubject.showValidationMessage(15.0, CBlankSubject))
            
        } else if (self.txtVMsg.text?.isBlank)! {
        self.vwContent.addSubview(self.txtVMsg.showValidationMessage(15.0,CBlankDocMsg,vwMsg.CViewX, vwMsg.CViewY))
            
            self.txtVMsg.textfiledAddRemoveShadow(true)
            self.showValidation(isAdd: true)
            _ = self.vwMsg.setConstraintConstant((30/2) + 30 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
        } else {
            self.postMaintenanceRequest()
        }
    }
    
    func setupPreview() {
        // Configure previewLayer
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    @IBAction func textDidChange(_ sender: Any) {
       
        if (txtSubject.text?.count)! > 75 {
            let currentText = txtSubject.text! as NSString
            txtSubject.text = currentText.substring(to: currentText.length - 1)
        }
    }
    
    @IBAction func btnUploadImage (sender : UIButton) {
        
        var actionSheet = UIAlertController()
        
        if IS_iPad {
            actionSheet = UIAlertController(title: "Please Select Camera or Photo Library", message: "", preferredStyle: .alert)
        } else {
            actionSheet = UIAlertController(title: "Please Select Camera or Photo Library", message: "", preferredStyle: .actionSheet)
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { (UIAlertAction) in
            self.presentImagePickerControllerWithCamera(allowEditing: false, allowMedia: false) { (image, data) in
                
                if let selectedImage = image {
                    self.setUploadedImg(img : selectedImage)
                    self.imgVPlay.isHidden = true
                    self.mediaType = 1
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Record Video", style: .default, handler: { (UIAlertAction) in
            
            self.presentImagePickerControllerWithCamera(allowEditing: true, allowMedia: true, imagePickerControllerCompletionHandler: { (image, info) in
            
                if info != nil {
                   
                    do {
                        let urlOfVideo = (info![UIImagePickerControllerMediaURL] as? NSURL)!
                        let asset = AVURLAsset(url: urlOfVideo as URL , options: nil)
                        let imgGenerator = AVAssetImageGenerator(asset: asset)
                        imgGenerator.appliesPreferredTrackTransform = true
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                        let thumbnail = UIImage(cgImage: cgImage)
                        self.setUploadedImg(img: thumbnail)
                        self.imgVPlay.isHidden = false
                        self.mediaType = 2
                    } catch let error {
                        print("*** Error generating thumbnail: \(error.localizedDescription)")
                    }
                }
            })

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Phone", style: .default, handler: { (UIAlertAction) in
            self.presentImagePickerControllerWithGallery(allowEditing: false, allowMedia: false) { (image, data) in
                
                if let selectedImage = image {
                    self.setUploadedImg(img : selectedImage)
                    self.imgVPlay.isHidden = true
                    self.mediaType = 1
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Video From Phone", style: .default, handler: { (UIAlertAction) in
            self.presentImagePickerControllerWithGallery(allowEditing: false, allowMedia: true) { (image, info) in
                print(info as Any)
                
                if info != nil {
                    do {
                        let urlOfVideo = (info![UIImagePickerControllerMediaURL] as? NSURL)!
                        let asset = AVURLAsset(url: urlOfVideo as URL , options: nil)
                        let imgGenerator = AVAssetImageGenerator(asset: asset)
                        imgGenerator.appliesPreferredTrackTransform = true
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                        let thumbnail = UIImage(cgImage: cgImage)
                        self.setUploadedImg(img: thumbnail)
                        self.imgVPlay.isHidden = false
                        self.imgData = try! Data(contentsOf: urlOfVideo as URL)
                        self.mediaType = 2
                    } catch let error {
                        print("*** Error generating thumbnail: \(error.localizedDescription)")
                    }
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setUploadedImg(img : UIImage) {
        imgVUpload.contentMode = .scaleAspectFit
        imgVUpload.image = img
        self.imgData = UIImageJPEGRepresentation(img, 0.5)!
    }
}

//MARK:-
//MARK:- UITextFieldDelegate
extension NewMaintenanceRequestViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField .isEqual(txtSubject) {
            txtSubject.hideValidationMessage(15.0)
        }
        return true
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension NewMaintenanceRequestViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.hideValidationMessage(15.0)
        self.showValidation(isAdd: false)
        _ = self.vwMsg.setConstraintConstant(IS_iPad ? 23 : 20, edge: .bottom, ancestor: true)
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = ColorGray
        }
    }
}


//MARK:-
//MARK:- API Method

extension NewMaintenanceRequestViewController {
    
    func postMaintenanceRequest() {
        
        let dict = ["maintenanceType" : maintenanceID,
                    "subject" : txtSubject.text as Any,
                    "message" : txtVMsg.text,
                    "mediaType" : mediaType]
        
        APIRequest.shared().postNewMaintenanceRequest(dict: dict as [String : AnyObject], mediaFile: imgData) { (response, error) in
            
            if response != nil {
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    self.showAlertView(metaData.valueForString(key: "message"), completion: nil)
                }
                
                for vwController in (self.navigationController?.viewControllers)! {
                    if vwController.isKind(of: MaintenanceViewController .classForCoder()){
                        let requestVC = vwController as? MaintenanceViewController
                        requestVC?.currentPage = 1
                        requestVC?.loadMaintenanceRequestList(showLoader : false)
                        self.navigationController?.popViewController(animated: true)
                        break
                    }
                }
            }
        }
    }
}
