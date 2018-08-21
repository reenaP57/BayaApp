//
//  ProjectDetailViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
//import CTPanoramaView
import BFRImageViewer

class ProjectDetailViewController: ParentViewController {

    @IBOutlet fileprivate weak var collProject : UICollectionView!
    @IBOutlet fileprivate weak var pageVProject : UIPageControl!

    @IBOutlet fileprivate weak var lblProjectName : UILabel!
    @IBOutlet fileprivate weak var lblProjectDesc : UILabel!
    @IBOutlet fileprivate weak var lblEmail : UILabel!
    @IBOutlet fileprivate weak var lblReraNo : UILabel!
    @IBOutlet fileprivate weak var lblPercentage : UILabel!
    @IBOutlet fileprivate weak var sliderPercentage : UISlider!
    
    @IBOutlet fileprivate weak var lblLocation : UILabel!
    @IBOutlet fileprivate weak var imgVLocation : UIImageView!
    
    @IBOutlet fileprivate weak var collLocation : UICollectionView!
    
    @IBOutlet fileprivate weak var collPlansType : UICollectionView!
    @IBOutlet fileprivate weak var collFloorImg : UICollectionView!
    @IBOutlet fileprivate weak var btnUnitPlans : UIButton!
    @IBOutlet fileprivate weak var btnTypicalPlan : UIButton!
    
    @IBOutlet fileprivate weak var collOverView : UICollectionView!

    @IBOutlet fileprivate weak var vw3DTour : UIView!
    @IBOutlet fileprivate weak var vw3DTitle : UIView!{
        didSet{
            vw3DTitle.layer.borderWidth = 1
            vw3DTitle.layer.borderColor = CRGB(r: 99, g: 89, b: 79).cgColor
        }
    }
    //@IBOutlet fileprivate weak var vwPanorama: CTPanoramaView!
    @IBOutlet fileprivate weak var vwPanorama: UIView!

    @IBOutlet fileprivate weak var tblConfigure : UITableView!
    @IBOutlet fileprivate weak var collAmmenities : UICollectionView!
    @IBOutlet fileprivate weak var tblSpecification : UITableView!

    @IBOutlet fileprivate weak var lblDisclaimer : UILabel!

    @IBOutlet fileprivate weak var cnstHeightCollOverView : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblConfigure : NSLayoutConstraint!
    @IBOutlet fileprivate weak var cnstHeightTblSpecification : NSLayoutConstraint!

    
    var arrLocation = [[String : AnyObject]]()
    var arrPlanType = [String]()
    var arrFloorImg = [String]()
    var arrOverView = [[String : AnyObject]]()
    var arrConfigure = [[String : AnyObject]]()
    var arrSpecification = [String]()
    var arrAmmenities = [[String : AnyObject]]()
    var arrImg = [String]()

    
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
        
        btnTypicalPlan.layer.borderWidth = 1
        btnTypicalPlan.layer.borderColor = ColorGray.cgColor
        
        arrImg = ["img1.jpeg","img2.jpeg","img3.jpeg"]
        
        arrLocation = [["img" : "metro", "title" : "Metro", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
        ["img" : "malls", "title" : "Malls", "desc" : ["Alfa One 2.0 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
        ["img" : "Hospital", "title" : "Hospitals", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
        ["img" : "schools", "title" : "Schools", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
        ["img" : "metro", "title" : "Metro", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]]] as [[String : AnyObject]]
        
        arrPlanType = ["TYPE A - 1 BHK", "TYPE B - 1 BHK", "TYPE d - 2 BHK", "TYPE e - 2 BHK", "TYPE c - 2 BHK", "TYPE f - 2 BHK"]
        
        arrFloorImg = ["img5.jpeg", "img6.jpeg", "img7.jpeg","img8.jpeg"]
        
        arrOverView = [["img" : "my_projects_profile", "title": "Project Details", "subtitle" : "3 Towers, 213 Units"],
        ["img" : "Forma_1_2", "title": "Possessions", "subtitle" : "Ready to move"],
        ["img" : "Forma_1", "title": "Launch Date", "subtitle" : "August 2015"],
        ["img" : "Forma_1_1", "title": "Parking", "subtitle" : "1 Parking available"],
        ["img" : "Layer_13", "title": "Plot Area", "subtitle" : "2500 sq.ft."],
        ["img" : "line", "title": "Number Of Storeys", "subtitle" : "22 Storeys Tower"]] as [[String : AnyObject]]
        
        arrConfigure = [["type" : "TYPE A - 1 BHK", "sq.ft" : "1350 sq.ft.", "price" : "4,50,000"],
        ["type" : "TYPE A - 2 BHK", "sq.ft" : "2350 sq.ft.", "price" : "7,00,000"],
        ["type" : "TYPE B - 2 BHK", "sq.ft" : "1000 sq.ft.", "price" : "7,00,000"],
        ["type" : "TYPE C - 2 BHK", "sq.ft" : "1500 sq.ft.", "price" : "7,00,000"],] as [[String : AnyObject]]
        
        arrAmmenities = [["img" : "Layer_7", "title" : "Lift"],
        ["img" : "Group_11", "title" : "Gym"],
        ["img" : "Group_12", "title" : "Swimming Pool"],
        ["img" : "Group_1", "title" : "Power Backup"]] as [[String : AnyObject]]
        
        arrSpecification = ["Drapes/Curtains/Window Cover", "Fire/Smoke Alarm", "Italian Kitchen", "Vitrified Tiles"]
        

        sliderPercentage.setMinimumTrackImage(appDelegate.setProgressGradient(frame: sliderPercentage.bounds), for: .normal)
        sliderPercentage.setThumbImage(UIImage(named: "baya_slider"), for: .normal)
        
        self.loadProjectDetail()
        
        //...Load 3D image
       // vwPanorama.image = UIImage(named: "spherical.jpg")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func loadProjectDetail () {
      
        DispatchQueue.main.async {
            self.updateCollectionAndTableHeight()
        }
    }
    
    func updateCollectionAndTableHeight() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.cnstHeightCollOverView.constant = self.collOverView.contentSize.height
            self.cnstHeightTblConfigure.constant = self.tblConfigure.contentSize.height
            self.cnstHeightTblSpecification.constant = self.tblSpecification.contentSize.height - 38
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
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnCallClicked (sender : UIButton) {
        self.dialPhoneNumber(phoneNumber: "123456789")

    }
    
    @IBAction func btnFloorPlansClicked (sender : UIButton) {
        
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
                
                cell.lblPlanType.text = dict.valueForString(key: "type")
                cell.lblSqft.text = dict.valueForString(key: "sq.ft")
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
            return arrFloorImg.count
        case collPlansType:
            return arrPlanType.count
        case collAmmenities:
            return arrAmmenities.count
        case collOverView:
            return arrOverView.count
        case collProject:
            return arrImg.count
        default:
            return arrLocation.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        switch collectionView {
        case collFloorImg:
            return CGSize(width: (CScreenWidth/2 - 20), height: (CScreenWidth * (190 / 375)))
            
        case collPlansType:
            let fontToResize = CFontAvenirLTStd(size: 12, type: .heavy).setUpAppropriateFont()
            return CGSize(width: arrPlanType[indexPath.row].size(withAttributes: [NSAttributedStringKey.font: fontToResize as Any]).width + 30, height: collectionView.CViewHeight)
            
        case collAmmenities:
            return CGSize(width: (CScreenWidth/4 - 20), height: collectionView.CViewHeight)
            
        case collOverView:
            return CGSize(width: (CScreenWidth/2 - 20), height: (CScreenWidth * (60/375)))
          
        case collProject:
            return CGSize(width: CScreenWidth, height: collProject.CViewHeight)
            
        default:
            return CGSize(width: (CScreenWidth/2 - 20), height: collectionView.contentSize.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch collectionView {
        case collProject:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectImageCollCell", for: indexPath) as? ProjectImageCollCell {
                cell.imgVProject.image = UIImage(named: arrImg[indexPath.row])
            
                return cell
            }
            return UICollectionViewCell()
            
        case collLocation:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationAdvantagesCollCell", for: indexPath) as? LocationAdvantagesCollCell {
                
                let dict = arrLocation[indexPath.row]
                
                cell.lblLocation.text = dict.valueForString(key: "title")
                cell.imgVLocation.image = UIImage(named: dict.valueForString(key: "img"))
                cell.loadLocationDesc(arrDesc: dict.valueForJSON(key: "desc") as! [String])
                
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.collLocation.reloadData()
                }
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case collPlansType:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanTypeCollCell", for: indexPath) as? PlanTypeCollCell {
         
                cell.lblPlanType.text = arrPlanType[indexPath.row]
                
                if cell.isSelected {
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
                
                cell.imgVPlan.image = UIImage(named: arrFloorImg[indexPath.row])
                
                return cell
            }
            
            return UICollectionViewCell()
            
        case collOverView:
        
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverViewCollCell", for: indexPath) as? OverViewCollCell {
                
                let dict = arrOverView[indexPath.row]
                
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
                cell.lblSubTitle.text = dict.valueForString(key: "subtitle")
                return cell
            }
            
            return UICollectionViewCell()
            
        default:
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmmenitiesCollCell", for: indexPath) as? AmmenitiesCollCell {
                
                let dict = arrAmmenities[indexPath.row]
                
                cell.lblTitle.text = dict.valueForString(key: "title")
                cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
                
                return cell
            }
            
            return UICollectionViewCell()
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case collPlansType:
            if let cell = collectionView.cellForItem(at: indexPath) as? PlanTypeCollCell {
                
                cell.isSelected = true
                cell.vwLine.isHidden = false
                cell.lblPlanType.textColor = ColorGreenSelected
            }
            
        case collFloorImg:
            if let cell = collectionView.cellForItem(at: indexPath) as? FloorPlansImgCollCell {
                 self.zoomImage(cell.imgVPlan.image)
            }
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView.isEqual(collPlansType){
            
            if let cell = collectionView.cellForItem(at: indexPath) as? PlanTypeCollCell {
                
                cell.isSelected = false
                cell.vwLine.isHidden = true
                cell.lblPlanType.textColor = ColorLightBlack
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        pageVProject.currentPage = Int(page)
 
    }
}
