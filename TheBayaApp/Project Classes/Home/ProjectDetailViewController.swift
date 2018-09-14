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

    @IBOutlet fileprivate weak var lblDisclaimer : UILabel!
    @IBOutlet fileprivate weak var scrollVw : UIScrollView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var vwBottom : UIView!

    @IBOutlet fileprivate weak var cnstHeightCollOverView : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblConfigure : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblSpecification : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightCollLocation : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightCollPlanType : NSLayoutConstraint!


    
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

    var projectID = 0
    var planIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
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
                self.activityLoader.stopAnimating()
                
                let dict = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                self.lblProjectName.text = dict.valueForString(key: CProjectName)
                self.lblProjectDesc.text = dict.valueForString(key: CDesciption)
                self.lblEmail.text = dict.valueForString(key: "website")
                self.lblReraNo.text = dict.valueForString(key: CReraNumber)
                self.lblPercentage.text = "\(dict.valueForInt(key: CProjectProgress) ?? 0)% Completed"
                self.lblLocation.text = dict.valueForString(key: CAddress)
                self.lblDisclaimer.text = dict.valueForString(key: "disclaimer")
                
                self.imgVLocation.sd_setShowActivityIndicatorView(true)
                self.imgVLocation.sd_setImage(with: URL(string: (dict.valueForString(key: "locationImage"))), placeholderImage: nil)

                self.btnSubscribe.isSelected = dict.valueForInt(key: CIsSubscribe) == 0 ? false : true
                
                self.sliderPercentage.setValue(Float(dict.valueForInt(key: CProjectProgress)!), animated: false)
                self.vwSoldOut.isHidden = dict.valueForInt(key: CIsSoldOut) == 0 ? true : false
                
                
                //...Load 3D image
                
                if let imgUrl = URL(string: dict.valueForString(key: "tour3DImage")){
                    do {
                        let imageData = try Data(contentsOf: imgUrl as URL)
                        self.vwPanorama.image = UIImage(data: imageData)
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                }
                
                
             
//
//                let data = Data.init(contentsOf: URL(string: dict.valueForString(key: "tour3DImage"))!)
//                self.vwPanorama.image = UIImage(data: data)
                
//
//                cell.imgVProject.sd_setShowActivityIndicatorView(true)
//
//
//                cell.imgVProject.sd_setImage(with: URL(string: arrProjectImg[indexPath.row] ), placeholderImage: nil, options: .retryFailed, completed: nil)
//
//                self.vwPanorama.image = UIImage(named: dict.valueForString(key: "tour3DImage"))
              

                //...Overview
                let arrTempOverView = dict.valueForJSON(key: "overview") as? [[String : AnyObject]]
                if (arrTempOverView?.count)! > 0{
                    self.arrOverView = arrTempOverView!
                }
                
              
                //...Location Advantges
                let arrTempLocAdvantges = dict.valueForJSON(key: "locationAdvantages") as? [[String : AnyObject]]
                if (arrTempLocAdvantges?.count)! > 0{
                    self.arrLocation = arrTempLocAdvantges!
                }
                
                
                //...Configurtion
                let arrTempConfiguration = dict.valueForJSON(key: "configuration") as? [[String : AnyObject]]
                if (arrTempConfiguration?.count)! > 0{
                    self.arrConfigure = arrTempConfiguration!
                }
                
               
                //...Project Imgaes
                let arrImg = dict.valueForJSON(key: "projectImages") as? [String]
                if (arrImg?.count)! > 0 {
                    self.arrProjectImg = arrImg!
                }
                
               
                //...Amenities
                let arrTempAmenities = dict.valueForJSON(key: "amenities") as? [[String : AnyObject]]
                if (arrTempAmenities?.count)! > 0 {
                    self.arrAmmenities = arrTempAmenities!
                }
                
                //...Specification
                let arrTempSepc = dict.valueForString(key: "specification").components(separatedBy:"\n")
                if arrTempSepc.count > 0{
                    self.arrSpecification = arrTempSepc
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
                    }
                    
                    //...Typical Plan
                    let arrTempTypicalPlan  = arrTempPlanType?.filter {
                        ($0.valueForString(key: "type")).range(of: "2" , options: [.caseInsensitive]) != nil
                    }
                    
                    if (arrTempTypicalPlan?.count)! > 0 {
                        self.arrTypicalPlan = arrTempTypicalPlan!
                        self.arrTypicalType = self.arrTypicalPlan.map({$0["title"]! as! String})

                    }
                    
                    print("arrUnitType : ",self.arrUnitType as Any)
                    print("arrTypicalType : ",self.arrTypicalType as Any)

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
            }
        }
        
    }
    
    func updateCollectionAndTableHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.cnstHeightCollOverView.constant = self.collOverView.contentSize.height
            self.cnstHeightTblConfigure.constant = self.tblConfigure.contentSize.height
            self.cnstHeightTblSpecification.constant =  IS_iPad ? self.tblSpecification.contentSize.height : self.tblSpecification.contentSize.height - 25
            self.cnstHeightCollLocation.constant = self.collLocation.contentSize.height
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
}


//MARK:-
//MARK:- Action

extension ProjectDetailViewController {
    
    @IBAction func btnBackClicked (sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLocatioImgClicked (sender : UIButton) {
        self.zoomImage(imgVLocation.image)
    }
    
    @IBAction func btnShareClicked (sender : UIButton) {
        
        let text = "This is the text...."
        let shareAll = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnScheduleVisitClicked (sender : UIButton) {
        
        if let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
            self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
        }
    }
    
    @IBAction func btnProjectBrochureClicked (sender : UIButton) {
        
        self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CProjectBrochureMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
    }
    
    @IBAction func btnSubscribeClicked (sender : UIButton) {
  
        self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: sender.isSelected ? CUnsubscribeMessage : CSubscribeMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
           
            self.btnSubscribe.isSelected ? self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg2"), for: .normal) : self.btnSubscribe.setBackgroundImage(#imageLiteral(resourceName: "gradient_bg1"), for: .normal)
            self.btnSubscribe.isSelected = !sender.isSelected
         
            APIRequest.shared().subcribedProject(self.projectID, type: self.btnSubscribe.isSelected ? 1 : 0) { (response, error) in
                
                if response != nil && error == nil {
                    
//                    let data = response?.value(forKey: CJsonData) as? [String : AnyObject]
//
//                    let vcProject = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectViewController") as? ProjectViewController
                    
                }
            }
            
        }, btnTwoTitle: CBtnCancel, btnTwoTapped: { (action) in
        })
    }
    
    @IBAction func btnCallClicked (sender : UIButton) {
        self.dialPhoneNumber(phoneNumber: "123456789")

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
            self.navigationController?.pushViewController(seeAllAmenitiesVC, animated: true)
        }
    }
    
    @IBAction func btnSeeAllLocationClicked (sender : UIButton) {
        
        if let seeAllLocVC = CStoryboardMain.instantiateViewController(withIdentifier: "SeeAllLocationAdvantagesViewController") as? SeeAllLocationAdvantagesViewController {
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
                cell.lblSqft.text = "\(dict.valueForString(key: "areaIn")) sq.ft"
                cell.lblPrice.text = "₹\(dict.valueForString(key: "price"))"

                return cell
            }
            
            return UITableViewCell()
            
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationTblCell") as? SpecificationTblCell {
                
                cell.lblTitle.text = arrSpecification[indexPath.row]

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
            return CGSize(width: CScreenWidth, height: collProject.CViewHeight)
            
        case collPlansType:
            let fontToResize = CFontAvenir(size: IS_iPad ? 14 : 12, type: .heavy).setUpAppropriateFont()
           
            let strTitle = self.btnUnitPlans.isSelected ? arrUnitType[indexPath.row] : arrTypicalType[indexPath.row]
            
            return CGSize(width: strTitle.size(withAttributes: [NSAttributedStringKey.font: fontToResize as Any]).width + 30, height: IS_iPad ? CScreenWidth * 60/768 : collectionView.CViewHeight)
            
        case collAmmenities:
            return IS_iPad ? CGSize(width:(collProject.CViewWidth/4 - 45), height: CScreenWidth * 120/768) : CGSize(width: (CScreenWidth/3 - 20), height: collectionView.CViewHeight)
            
        case collOverView:
            return CGSize(width: IS_iPad ? (collProject.CViewWidth/2 - 50):(CScreenWidth/2 - 20), height: IS_iPad ? (CScreenWidth * (90/768)) : (CScreenWidth * (60/375)))
          
        case collProject:
            return CGSize(width: CScreenWidth, height: collProject.CViewHeight)
            
        default:
            return IS_iPad ? CGSize(width: (collProject.CViewWidth/3 - 20), height: collectionView.contentSize.height) : CGSize(width: (CScreenWidth/2 - 20), height: collectionView.contentSize.height)
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

                let arrDesc = dict.valueForString(key: CDesciption).components(separatedBy:"\n")
                if arrDesc.count > 0 {
                    cell.loadLocationDesc(arrDesc: arrDesc)
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
                cell.lblSubTitle.text = dict.valueForString(key: CDesciption)
                
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
