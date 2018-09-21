//
//  ProjectDetailViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CTPanoramaView
import BFRImageViewer

class ProjectDetailViewController: ParentViewController {

    @IBOutlet fileprivate weak var vwOverView : UIView!
    @IBOutlet fileprivate weak var vwLocAdvantages : UIView!
    @IBOutlet fileprivate weak var vwConfigurtion : UIView!
    @IBOutlet fileprivate weak var vwFloorPlan : UIView!
    @IBOutlet fileprivate weak var vwAmenities : UIView!
    @IBOutlet fileprivate weak var vwSpecification : UIView!


    @IBOutlet fileprivate weak var collProject : UICollectionView!
    @IBOutlet fileprivate weak var pageVProject : UIPageControl!
    @IBOutlet fileprivate weak var vwSoldOut : UIView!

    @IBOutlet fileprivate weak var lblProjectName : UILabel!
    @IBOutlet fileprivate weak var lblProjectDesc : UILabel!
    @IBOutlet fileprivate weak var lblEmail : UILabel!
    @IBOutlet fileprivate weak var lblReraNo : UILabel!
    @IBOutlet fileprivate weak var lblPercentage : UILabel!
    @IBOutlet fileprivate weak var sliderPercentage : UISlider!
    @IBOutlet fileprivate weak var btnSubscribe : UIButton!

    @IBOutlet fileprivate weak var lblLocation : UILabel!
    @IBOutlet fileprivate weak var imgVLocation : UIImageView!
    
    @IBOutlet fileprivate weak var collLocation : UICollectionView!
    
    @IBOutlet fileprivate weak var collPlansType : UICollectionView!
    @IBOutlet fileprivate weak var collFloorImg : UICollectionView!
    @IBOutlet fileprivate weak var btnUnitPlans : UIButton!
    @IBOutlet fileprivate weak var btnTypicalPlan : UIButton!
    
    @IBOutlet fileprivate weak var collOverView : UICollectionView!

    @IBOutlet fileprivate weak var vwProjectDetail : UIView!

    @IBOutlet fileprivate weak var vwMain3DTour : UIView!
    @IBOutlet fileprivate weak var vw3DTour : UIView!
    @IBOutlet fileprivate weak var vw3DTitle : UIView!{
        didSet{
            vw3DTitle.layer.borderWidth = 1
            vw3DTitle.layer.borderColor = CRGB(r: 99, g: 89, b: 79).cgColor
        }
    }
    @IBOutlet fileprivate weak var vwPanorama: CTPanoramaView!

    @IBOutlet fileprivate weak var tblConfigure : UITableView!
    @IBOutlet fileprivate weak var collAmmenities : UICollectionView!
    @IBOutlet fileprivate weak var tblSpecification : UITableView!

    @IBOutlet fileprivate weak var btnSeeAllAmenities : UIButton!
    @IBOutlet fileprivate weak var btnSeeAllAdvantages : UIButton!
    @IBOutlet fileprivate weak var btnScheduleVisit : UIButton!
    @IBOutlet fileprivate weak var btnProjectBrochure : UIButton!

    @IBOutlet fileprivate weak var lblDisclaimer : UILabel!
    @IBOutlet fileprivate weak var scrollVw : UIScrollView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var vwBottom : UIView!
    @IBOutlet fileprivate weak var vwNav : UIView!

    @IBOutlet fileprivate weak var cnstHeightCollOverView : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblConfigure : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblSpecification : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightCollLocation : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstXPointBrochureBtn : NSLayoutConstraint!


    
    var arrLocation = [[String : AnyObject]]()
    var arrOverView = [[String : AnyObject]]()
    var arrConfigure = [[String : AnyObject]]()
    var arrSpecification = [String]()
    var arrAmmenities = [[String : AnyObject]]()
    var arrProjectImg = [String]()
    var arrUnitPlan = [[String : AnyObject]]()
    var arrTypicalPlan = [[String : AnyObject]]()
    var arrUnitType = [String]()
    var arrTypicalType = [String]()
    var arrContactNo = [[String : AnyObject]]()
    var arrCollLocationHeight = [CGFloat]()
    
    
    var projectID = 0
    var planIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    var dictDetail = [String : AnyObject]()
    var collLocHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        
        self.btnFloorPlansClicked(sender: btnUnitPlans)
        
        //... Set delegate for custom layout location collection
        if let layout = collLocation.collectionViewLayout as? LocationAdvantagesLayout {
            layout.delegate = self
        }
        
        tblSpecification.estimatedRowHeight = 32.0
        tblSpecification.rowHeight = UITableViewAutomaticDimension
        
        vwSoldOut.layer.borderWidth = 1
        vwSoldOut.layer.borderColor = CRGB(r: 255, g: 0, b: 0).cgColor
        
        sliderPercentage.setMinimumTrackImage(appDelegate.setProgressGradient(frame: sliderPercentage.bounds), for: .normal)
        sliderPercentage.setThumbImage(UIImage(named: "baya_slider_shadow"), for: .normal)
        
        self.loadProjectDetailFromServer()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func loadProjectDetailFromServer () {
        
        scrollVw.isHidden = true
        vwBottom.isHidden = true
        activityLoader.startAnimating()
        
        
        APIRequest.shared().getProjectDetail(projectId: self.projectID) { (response, error) in
            
            if response != nil && error == nil {
                
                self.scrollVw.isHidden = false
                self.vwBottom.isHidden = false
                self.vwNav.isHidden = true
                self.activityLoader.stopAnimating()
                
                
                let dict = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                self.dictDetail = dict
                
                self.lblProjectName.text = "\(dict.valueForString(key: CProjectName)), \(dict.valueForString(key: "shortLocation"))"
                self.lblProjectDesc.text = dict.valueForString(key: CDescription)
                self.lblEmail.text = dict.valueForString(key: "website")
                self.lblReraNo.text = dict.valueForString(key: CReraNumber)
                self.lblPercentage.text = "\(dict.valueForInt(key: CProjectProgress) ?? 0)% Completed"
                self.lblLocation.text = dict.valueForString(key: CAddress)
                self.lblDisclaimer.text = dict.valueForString(key: "disclaimer")
                
                self.imgVLocation.sd_setShowActivityIndicatorView(true)
                self.imgVLocation.sd_setImage(with: URL(string: (dict.valueForString(key: "locationImage"))), placeholderImage: nil)
           
               
                if dict.valueForInt(key: CIsSubscribe) == 0 {
                    self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg2"),for: .normal)
                    self.btnSubscribe.isSelected = false
                } else {
                    self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg1"), for: .normal)
                    self.btnSubscribe.isSelected = true
                }
                
                
                self.sliderPercentage.setValue(Float(dict.valueForInt(key: CProjectProgress)!), animated: false)
                self.vwSoldOut.isHidden = dict.valueForInt(key: CIsSoldOut) == 0 ? true : false
                
                if dict.valueForInt(key: CIsVisit) == 0 {
                    
                     self.btnScheduleVisit.isHidden = true
                    
                    if IS_iPhone {
                        self.cnstXPointBrochureBtn.constant = 0
                    } else {
                        _ = self.btnProjectBrochure.setConstraintConstant(-(self.btnScheduleVisit.CViewWidth/2), edge: .leading, ancestor: true)
                        _ = self.btnProjectBrochure.setConstraintConstant(self.btnScheduleVisit.CViewWidth/2, edge: .trailing, ancestor: true)
                    }
                   
                }
                
                
                //...Contact Detail
                
                let arrTempContact = dict.valueForJSON(key: "contactDetail") as? [[String : AnyObject]]
                
                if (arrTempContact?.count)! > 0 {
                    self.arrContactNo = arrTempContact!
                }
                
                
                //...Load 3D image
                
                if dict.valueForString(key: "tour3DImage") == "" {
                    IS_iPad ? self.vw3DTour.hide(byHeight: true) : self.vwMain3DTour.hide(byHeight: true)
                }
                
                if let imgUrl = URL(string: dict.valueForString(key: "tour3DImage")){
                    do {
                        let imageData = try Data(contentsOf: imgUrl as URL)
                        let img = UIImage(data: imageData)
                        self.vwPanorama.image = img
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
                
                //...Overview
                let arrTempOverView = dict.valueForJSON(key: "overview") as? [[String : AnyObject]]
                if (arrTempOverView?.count)! > 0{
                    self.arrOverView = arrTempOverView!
                } else {
                    self.vwOverView.hide(byHeight: true)
                }
                
              
                //...Location Advantges
                let arrTempLocAdvantges = dict.valueForJSON(key: "locationAdvantages") as? [[String : AnyObject]]
                if (arrTempLocAdvantges?.count)! > 0 {
                   
                    if IS_iPhone && (arrTempLocAdvantges?.count)! > 3 {
                        self.btnSeeAllAdvantages.isHidden = false
                        
                        for index in 1..<4 {
                            self.arrLocation.append(arrTempLocAdvantges![index])
                        }
                    
                    } else if IS_iPad  && (arrTempLocAdvantges?.count)! > 4 {
                        self.btnSeeAllAdvantages.isHidden = false
                        for index in 1..<5 {
                            self.arrLocation.append(arrTempLocAdvantges![index])
                        }
                    } else {
                         self.btnSeeAllAdvantages.isHidden = true
                         self.arrLocation = arrTempLocAdvantges!
                    }
                    
                } else {
                    self.vwLocAdvantages.hide(byHeight: true)
                }
                
                
                //...Configurtion
                let arrTempConfiguration = dict.valueForJSON(key: "configuration") as? [[String : AnyObject]]
                if (arrTempConfiguration?.count)! > 0{
                    self.arrConfigure = arrTempConfiguration!
                } else {
                    self.vwConfigurtion.hide(byHeight: true)
                }
                
               
                //...Project Imgaes
                let arrImg = dict.valueForJSON(key: "projectImages") as? [String]
                self.pageVProject.numberOfPages = (arrImg?.count)!
                
                if (arrImg?.count)! > 0 {
                    self.arrProjectImg = arrImg!
                    self.pageVProject.isHidden = false
                } else{
                    self.pageVProject.isHidden = true
                }
                
               
                //...Amenities
                let arrTempAmenities = dict.valueForJSON(key: "amenities") as? [[String : AnyObject]]
                if (arrTempAmenities?.count)! > 0 {
                    
                    if IS_iPhone && (arrTempAmenities?.count)! > 3 {
                        self.btnSeeAllAmenities.isHidden = false
                        for index in 1..<4 {
                            self.arrAmmenities.append(arrTempAmenities![index])
                        }
                        
                    } else if IS_iPad  && (arrTempAmenities?.count)! > 4 {
                        self.btnSeeAllAmenities.isHidden = false
                        for index in 1..<5 {
                            self.arrAmmenities.append(arrTempAmenities![index])
                        }
                    } else {
                        self.btnSeeAllAmenities.isHidden = true
                        self.arrAmmenities = arrTempAmenities!
                    }
                    
                } else {
                    self.vwAmenities.hide(byHeight: true)
                }
                
                //...Specification
                let arrTempSepc = dict.valueForString(key: "specification").components(separatedBy:"\n")
                if arrTempSepc.count > 0{
                    self.arrSpecification = arrTempSepc
                } else {
                    self.vwSpecification.hide(byHeight: true)
                }
                
                
                //...Floor Plan
                let arrTempPlanType = dict.valueForJSON(key: "floorPlan") as? [[String : AnyObject]]
                if (arrTempPlanType?.count)! > 0{
                    
                    //...Unit Plan
                    let arrTempUnitPlan = arrTempPlanType?.filter {
                        ($0.valueForString(key: "type")).range(of: "1" , options: [.caseInsensitive]) != nil
                    }
                    
                    if (arrTempUnitPlan?.count)! > 0 {
                        self.arrUnitPlan = arrTempUnitPlan!
                        self.arrUnitType = self.arrUnitPlan.map({$0["title"]! as! String})
                    } else {
                        self.btnUnitPlans.hide(byWidth: true)
                    }
                    
                    
                    //...Typical Plan
                    let arrTempTypicalPlan  = arrTempPlanType?.filter {
                        ($0.valueForString(key: "type")).range(of: "2" , options: [.caseInsensitive]) != nil
                    }
                    
                    if (arrTempTypicalPlan?.count)! > 0 {
                        self.arrTypicalPlan = arrTempTypicalPlan!
                        self.arrTypicalType = self.arrTypicalPlan.map({$0["title"]! as! String})

                    } else {
                        self.btnTypicalPlan.hide(byWidth: true)
                    }
                    
                    print("arrUnitType : ",self.arrUnitType as Any)
                    print("arrTypicalType : ",self.arrTypicalType as Any)

                } else {
                    self.vwFloorPlan.hide(byHeight: true)
                }
                
                
                self.collProject.reloadData()
                self.collOverView.reloadData()
                self.collLocation.reloadData()
                self.tblConfigure.reloadData()
                self.collPlansType.reloadData()
                self.collFloorImg.reloadData()
                self.collAmmenities.reloadData()
                self.tblSpecification.reloadData()

                
                DispatchQueue.main.async {
                    self.updateCollectionAndTableHeight()
                }
            
                
            } else {
                 self.vwNav.isHidden = false
            }
        }
        
    }

    func updateCollectionAndTableHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.cnstHeightCollOverView.constant = self.collOverView.contentSize.height
            self.cnstHeightTblConfigure.constant = self.tblConfigure.contentSize.height
            self.cnstHeightTblSpecification.constant = self.tblSpecification.contentSize.height
            
            if self.arrCollLocationHeight.count > 0 {
                self.cnstHeightCollLocation.constant = self.arrCollLocationHeight.max()!
            }
        }
    }

    func zoomImage(_ image : UIImage?)
    {
        if image != nil
        {
            DispatchQueue.main.async {
                let imageVC = BFRImageViewController(imageSource: [image!])
                imageVC?.isUsingTransparentBackground = false
                self.present(imageVC!, animated: true, completion: nil)
            }
        }
    }
    
    func estimateFrameForText(locAdvantages: String, location : String) -> CGFloat {
        //we make the height arbitrarily large so we don't undershoot height in calculation
       
        let height: CGFloat = 500
        let size = CGSize(width: IS_iPad ? (CScreenWidth/4 - 20) : (CScreenWidth/3 - 15) , height: height)
        let options =  NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: CFontAvenir(size: 12, type: .medium).setUpAppropriateFont()!]
        let attributes1 = [NSAttributedStringKey.font: CFontAvenir(size: 13, type: .medium).setUpAppropriateFont()!]
        
        return IS_iPad ? NSString(string: locAdvantages).boundingRect(with: size, options: options, attributes: attributes, context: nil).height +  NSString(string: location).boundingRect(with: size, options: options, attributes: attributes1, context: nil).height + 110 : NSString(string: locAdvantages).boundingRect(with: size, options: options, attributes: attributes, context: nil).height +  NSString(string: location).boundingRect(with: size, options: options, attributes: attributes1, context: nil).height + 70
    }
}


//MARK:-
//MARK:- Action

extension ProjectDetailViewController {
    
    @IBAction func btnNavBackClicked (sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackClicked (sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLocatioImgClicked (sender : UIButton) {
        self.zoomImage(imgVLocation.image)
    }
    
    @IBAction func btnShareClicked (sender : UIButton) {
        
        let contactNo = (arrContactNo.mapValue(forKey: "mobileNo") as? [String])?.joined(separator: ",")
        
        let text = "\(dictDetail.valueForString(key: CProjectName))\n\nMahaRERA: \(dictDetail.valueForString(key: CReraNumber))\n\nCall \(contactNo!)\n\n\(dictDetail.valueForString(key: "website"))\n\nSite Address: \(dictDetail.valueForString(key: CAddress))\n\n\(dictDetail.valueForString(key: CDescription))"
        
        let shareAll = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnScheduleVisitClicked (sender : UIButton) {
        
        if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
            scheduleVisitVC.projectId = dictDetail.valueForInt(key: CProjectId)!
            scheduleVisitVC.projectName = dictDetail.valueForString(key: CProjectName)
            self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
        }
    }
    
    @IBAction func btnProjectBrochureClicked (sender : UIButton) {
        
        APIRequest.shared().projectBrochure(projectId: self.projectID) { (response, error) in
            
            if response != nil && error == nil {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CProjectBrochureMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    @IBAction func btnSubscribeClicked (sender : UIButton) {
  
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: sender.isSelected ? CUnsubscribeMessage : CSubscribeMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
           
            self.btnSubscribe.isSelected ? self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg2"), for: .normal) : self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg1"), for: .normal)
            self.btnSubscribe.isSelected = !sender.isSelected
         
            APIRequest.shared().subcribedProject(self.projectID, type: self.btnSubscribe.isSelected ? 1 : 0) { (response, error) in
                
                if response != nil && error == nil {
                    
                    let data = response?.value(forKey: CJsonData) as! [String : AnyObject]
                    
                    appDelegate.loginUser?.postBadge = Int16(data.valueForInt(key: CFavoriteProjectBadge)!)
                    appDelegate.loginUser?.projectProgress = Int16(data.valueForInt(key: CFavoriteProjectProgress)!)
                    appDelegate.loginUser?.project_name = data.valueForString(key: CFavoriteProjectName)
                    
                    CoreData.saveContext()
                    
                    for vwController in (self.navigationController?.viewControllers)! {
                        
                        if vwController.isKind(of: ProjectViewController .classForCoder()){
                            
                            let projectVC = vwController as? ProjectViewController
                            projectVC?.refreshIsSubscribedStatus(projectId: self.projectID, isSubscribed: data.valueForInt(key: CIsSubscribe)!)
                            
                            break
                        }
                    }
                }
            }
            
        }, btnTwoTitle: CBtnCancel, btnTwoTapped: { (action) in
        })
    }
    
    @IBAction func btnCallClicked (sender : UIButton) {
        
        if arrContactNo.count == 1 {
            self.dialPhoneNumber(phoneNumber: arrContactNo[0].valueForString(key: "mobileNo"))
       
        } else {
            
            if IS_iPad {
                
                let actionSheet = UIAlertController(title: "Contact Detail", message: "", preferredStyle: .alert)
                
                actionSheet.addAction(UIAlertAction(title: self.arrContactNo[0].valueForString(key: "mobileNo"), style: .default, handler: { (UIAlertAction) in
                    self.dialPhoneNumber(phoneNumber: self.arrContactNo[0].valueForString(key: "mobileNo"))
                }))
                
                actionSheet.addAction(UIAlertAction(title: self.arrContactNo[1].valueForString(key: "mobileNo"), style: .default, handler: { (UIAlertAction) in
                    self.dialPhoneNumber(phoneNumber: self.arrContactNo[1].valueForString(key: "mobileNo"))
                }))
                
                if arrContactNo.count == 3 {
                    actionSheet.addAction(UIAlertAction(title: self.arrContactNo[3].valueForString(key: "mobileNo"), style: .default, handler: { (UIAlertAction) in
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[3].valueForString(key: "mobileNo"))
                    }))
                }
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)
                
                
            } else {
                
                if arrContactNo.count == 2 {
                    
                    self.presentActionsheetWithTwoButtons(actionSheetTitle: "", actionSheetMessage:"Contact Detail", btnOneTitle: self.arrContactNo[0].valueForString(key: "mobileNo"), btnOneStyle: .default, btnOneTapped: { (action) in
                        
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[0].valueForString(key: "mobileNo"))
                        
                    }, btnTwoTitle: self.arrContactNo[1].valueForString(key: "mobileNo"), btnTwoStyle: .default) { (action) in
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[1].valueForString(key: "mobileNo"))
                        
                    }
                    
                } else {
                    
                    self.presentActionsheetWithThreeButton(actionSheetTitle: "Contact", actionSheetMessage: "", btnOneTitle: self.arrContactNo[0].valueForString(key: "mobileNo"), btnOneStyle: .default, btnOneTapped: { (action) in
                        
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[0].valueForString(key: "mobileNo"))
                        
                    }, btnTwoTitle: self.arrContactNo[1].valueForString(key: "mobileNo"), btnTwoStyle: .default, btnTwoTapped: { (action) in
                        
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[1].valueForString(key: "mobileNo"))
                        
                    }, btnThreeTitle: self.arrContactNo[2].valueForString(key: "mobileNo"), btnThreeStyle: .default) { (action) in
                        
                        self.dialPhoneNumber(phoneNumber: self.arrContactNo[2].valueForString(key: "mobileNo"))
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func btnFloorPlansClicked (sender : UIButton) {
        
        btnUnitPlans.isSelected = false
        btnTypicalPlan.isSelected = false
        btnUnitPlans.backgroundColor = UIColor.clear
        btnTypicalPlan.backgroundColor = UIColor.clear
        btnTypicalPlan.layer.borderWidth = 1
        btnUnitPlans.layer.borderWidth = 1
        btnTypicalPlan.layer.borderColor = ColorGray.cgColor
        btnUnitPlans.layer.borderColor = ColorGray.cgColor
        
        if sender.isSelected {
            return
        }
        
        sender.isSelected = true
        sender.backgroundColor = ColorGreenSelected
        sender.layer.borderColor = ColorGreenSelected.cgColor
  
        self.collPlansType.reloadData()
        self.collFloorImg.reloadData()
        
    }
    
    @IBAction func btnSeeAllAmenitiesClicked (sender : UIButton) {
        
        if let seeAllAmenitiesVC = CStoryboardMain.instantiateViewController(withIdentifier: "SeeAllAmenitiesViewController") as? SeeAllAmenitiesViewController {
            seeAllAmenitiesVC.projectId = self.projectID
            self.navigationController?.pushViewController(seeAllAmenitiesVC, animated: true)
        }
    }
    
    @IBAction func btnSeeAllLocationClicked (sender : UIButton) {
        
        if let seeAllLocVC = CStoryboardMain.instantiateViewController(withIdentifier: "SeeAllLocationAdvantagesViewController") as? SeeAllLocationAdvantagesViewController {
             seeAllLocVC.projectId = self.projectID
            self.navigationController?.pushViewController(seeAllLocVC, animated: true)
        }
    }
    
    @IBAction func btn3DZoomClicked (sender : UIButton) {
        
        if let zoom3DVC = CStoryboardMain.instantiateViewController(withIdentifier: "Zoom3DImageViewController") as? Zoom3DImageViewController {
            self.navigationController?.present(zoom3DVC, animated: true, completion: nil)
        }
    }
}

//MARK:-
//MARK:- Custom layout delegate

extension ProjectDetailViewController : LocationAdvantagesLayoutDelegate {
    
    // 1. Returns the cell height
    func collectionView(_ collectionView: UICollectionView, heightForLocationAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        var height: CGFloat = 500
        
        //we are just measuring height so we add a padding constant to give the label some room to breathe!
        let padding: CGFloat = 0
        
        let dict = arrLocation[indexPath.row]
        
        let strLocation = (dict.valueForString(key: CDescription)).replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        //estimate each cell's height
        height = estimateFrameForText(locAdvantages: strLocation, location : (dict.valueForString(key: CTitle))) + padding
        
        self.arrCollLocationHeight.append(height)
        
      //  return IS_iPad ? CGSize(width: (collProject.CViewWidth/3 - 20), height: collectionView.contentSize.height) : CGSize(width: (CScreenWidth/3 - 20), height: height)
        
        return height
    }
    
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension ProjectDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView .isEqual(tblConfigure) ? arrConfigure.count : arrSpecification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView .isEqual(tblConfigure) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigurationTblCell") as? ConfigurationTblCell {
                
                let dict = arrConfigure[indexPath.row]
                
                cell.lblPlanType.text = dict.valueForString(key: "unitDetail")
                cell.lblSqft.text = dict.valueForString(key: "areaIn")
                cell.lblPrice.text = dict.valueForString(key: "price")

                return cell
            }
            
            return UITableViewCell()
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationTblCell") as? SpecificationTblCell {
                
                cell.lblTitle.text = (arrSpecification[indexPath.row]).replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
                return cell
            }
            
            return UITableViewCell()
        }

    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension ProjectDetailViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch collectionView {
        case collFloorImg:
            return self.btnUnitPlans.isSelected ? arrUnitPlan.count : arrTypicalPlan.count
        case collPlansType:
            return self.btnUnitPlans.isSelected ? arrUnitType.count : arrTypicalType.count
        case collAmmenities:
            return arrAmmenities.count
        case collOverView:
            return arrOverView.count
        case collProject:
            return arrProjectImg.count
        default:
            return arrLocation.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        switch collectionView {
        case collFloorImg:
            return IS_iPad ? CGSize(width: collFloorImg.CViewWidth, height: collFloorImg.CViewHeight) : CGSize(width: CScreenWidth, height: collFloorImg.CViewHeight)
            
        case collPlansType:
            let fontToResize = CFontAvenir(size: IS_iPad ? 14 : 12, type: .heavy).setUpAppropriateFont()
           
            let strTitle = self.btnUnitPlans.isSelected ? arrUnitType[indexPath.row] : arrTypicalType[indexPath.row]
            
            return CGSize(width: strTitle.size(withAttributes: [NSAttributedStringKey.font: fontToResize as Any]).width + 30, height: IS_iPad ? CScreenWidth * 60/768 : collectionView.CViewHeight)
            
        case collAmmenities:
            return IS_iPad ? CGSize(width:(collProject.CViewWidth/4 - 45), height: CScreenWidth * 130/768) : CGSize(width: (CScreenWidth/3 - 20), height: collectionView.CViewHeight)
            
        case collOverView:
            return CGSize(width: IS_iPad ? (collProject.CViewWidth/2 - 50):(CScreenWidth/2 - 20), height: IS_iPad ? (CScreenWidth * (90/768)) : (CScreenWidth * (60/375)))
          
        case collProject:
            return CGSize(width: CScreenWidth, height: collProject.CViewHeight)
        default:
            return CGSize(width: 0, height: 0)
            print("")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        case collProject:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectImageCollCell", for: indexPath) as? ProjectImageCollCell {
                
                cell.imgVProject.sd_setShowActivityIndicatorView(true)
                cell.imgVProject.sd_setImage(with: URL(string: arrProjectImg[indexPath.row] ), placeholderImage: nil, options: .retryFailed, completed: nil)
                
                return cell
            }
            return UICollectionViewCell()
            
        case collLocation:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationAdvantagesCollCell", for: indexPath) as? LocationAdvantagesCollCell {
                
                let dict = arrLocation[indexPath.row]
                
                cell.lblLocation.text = dict.valueForString(key: CTitle)
                cell.imgVLocation.sd_setShowActivityIndicatorView(true)
                cell.imgVLocation.sd_setImage(with: URL(string: dict.valueForString(key: CIcon)), placeholderImage: nil, options: .retryFailed, completed: nil)

             //   cell.lblLocAdvantages.text =
                
                let arrDesc = dict.valueForString(key: CDescription).components(separatedBy:"\n")
                if arrDesc.count > 0 {
                   cell.lblLocAdvantages.text =
                    (dict.valueForString(key: CDescription)).replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
                    //cell.loadLocationDesc(arrDesc: arrDesc)
                }
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case collPlansType:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanTypeCollCell", for: indexPath) as? PlanTypeCollCell {
         
                cell.lblPlanType.text = self.btnUnitPlans.isSelected ? arrUnitType[indexPath.row] : arrTypicalType[indexPath.row]
                
                if self.planIndexPath == indexPath {
                    cell.vwLine.isHidden = false
                    cell.lblPlanType.textColor = ColorGreenSelected
                    
                } else {
                    cell.vwLine.isHidden = true
                    cell.lblPlanType.textColor = ColorLightBlack
                }
               
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case collFloorImg:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FloorPlansImgCollCell", for: indexPath) as? FloorPlansImgCollCell {
                
                let dic = self.btnUnitPlans.isSelected ? arrUnitPlan[indexPath.row] : arrTypicalPlan[indexPath.row]
                
                cell.imgVPlan.sd_setShowActivityIndicatorView(true)
                cell.imgVPlan.sd_setImage(with: URL(string: dic.valueForString(key: CImage) ), placeholderImage: nil, options: .retryFailed, completed: nil)
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case collOverView:
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverViewCollCell", for: indexPath) as? OverViewCollCell {
                
                let dict = arrOverView[indexPath.row]
                
                cell.lblTitle.text = dict.valueForString(key: CTitle)
                cell.lblSubTitle.text = dict.valueForString(key: CDescription)
                
                cell.imgVTitle.sd_setShowActivityIndicatorView(true)
                cell.imgVTitle.sd_setImage(with: URL(string: dict.valueForString(key: CIcon)), placeholderImage: nil, options: .retryFailed, completed: nil)
                
                return cell
            }
            
            return UICollectionViewCell()
            
        default:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmmenitiesCollCell", for: indexPath) as? AmmenitiesCollCell {
                
                let dict = arrAmmenities[indexPath.row]
                
                cell.lblTitle.text = dict.valueForString(key: CTitle)
                
                cell.imgVTitle.sd_setShowActivityIndicatorView(true)
                cell.imgVTitle.sd_setImage(with: URL(string: dict.valueForString(key: CIcon) ), placeholderImage: nil, options: .retryFailed, completed: nil)
                
                return cell
            }
            
            return UICollectionViewCell()
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case collPlansType:
            self.planIndexPath = indexPath
            
            self.collFloorImg.scrollToItem(at: indexPath, at: IS_iPad ? .top : .left, animated: true)
            self.collPlansType.reloadData()

        case collFloorImg:
            if let cell = collectionView.cellForItem(at: indexPath) as? FloorPlansImgCollCell {
                 self.zoomImage(cell.imgVPlan.image)
            }
            
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = IS_iPad ? round(scrollView.contentOffset.y/scrollView.bounds.size.height) : round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        
        if scrollView == collFloorImg {
            
            let count = self.btnUnitPlans.isSelected ? arrUnitType.count : arrTypicalType.count
            
            if Int(index) <= count - 1 {
                collPlansType.scrollToItem(at: IndexPath(item: Int(index), section: 0), at: IS_iPad ? .top : .left, animated: true)
                self.planIndexPath = IndexPath(item: Int(index), section: 0)
                collPlansType.reloadData()
            }
            
        } else {
            
            pageVProject.currentPage = Int(index)
        }
    }
}
