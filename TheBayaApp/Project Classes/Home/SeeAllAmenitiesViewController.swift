//
//  SeeAllAmenitiesViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SeeAllAmenitiesViewController: ParentViewController {

    @IBOutlet fileprivate weak var collAmenities : UICollectionView!
    
    var arrAmmenities = [[String : AnyObject]]()
    
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
        
        self.title = "Amenities"
        
        if IS_iPad {
            
            arrAmmenities = [["img" : "ammenitie1_ipad", "title" : "Lift"],
                             ["img" : "ammenitie2_ipad", "title" : "Gym"],
                             ["img" : "ammenitie3_ipad", "title" : "Swimming Pool"],
                             ["img" : "ammenitie4_ipad", "title" : "Power Backup"],
                             ["img" : "ammenitie1_ipad", "title" : "Gym"],
                             ["img" : "ammenitie2_ipad", "title" : "Swimming Pool"],
                             ["img" : "ammenitie3_ipad", "title" : "Power Backup"],
                             ["img" : "ammenitie4_ipad", "title" : "Lift"],
                             ["img" : "ammenitie1_ipad", "title" : "Lift"],
                             ["img" : "ammenitie2_ipad", "title" : "Gym"],
                             ["img" : "ammenitie3_ipad", "title" : "Swimming Pool"],
                             ["img" : "ammenitie4_ipad", "title" : "Power Backup"],
                             ["img" : "ammenitie1_ipad", "title" : "Gym"],
                             ["img" : "ammenitie2_ipad", "title" : "Swimming Pool"],
                             ["img" : "ammenitie3_ipad", "title" : "Power Backup"],
                             ["img" : "ammenitie4_ipad", "title" : "Lift"]] as [[String : AnyObject]]
            
        } else {
            
            arrAmmenities = [["img" : "Layer_7", "title" : "Lift"],
                             ["img" : "Group_11", "title" : "Gym"],
                             ["img" : "Group_12", "title" : "Swimming Pool"],
                             ["img" : "Group_1", "title" : "Power Backup"],
                             ["img" : "Group_11", "title" : "Gym"],
                             ["img" : "Group_12", "title" : "Swimming Pool"],
                             ["img" : "Group_1", "title" : "Power Backup"],
                             ["img" : "Layer_7", "title" : "Lift"],
                             ["img" : "Layer_7", "title" : "Lift"],
                             ["img" : "Group_11", "title" : "Gym"],
                             ["img" : "Group_12", "title" : "Swimming Pool"],
                             ["img" : "Group_1", "title" : "Power Backup"],
                             ["img" : "Group_11", "title" : "Gym"],
                             ["img" : "Group_12", "title" : "Swimming Pool"],
                             ["img" : "Group_1", "title" : "Power Backup"],
                             ["img" : "Layer_7", "title" : "Lift"]] as [[String : AnyObject]]
        }
        
 
    }
    
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension SeeAllAmenitiesViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAmmenities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        return CGSize(width: IS_iPad ?(CScreenWidth/4 - 50) : (CScreenWidth/4 - 20), height: IS_iPad ? CScreenWidth * (140/CScreenWidth) :  CScreenWidth * (100/CScreenWidth))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmmenitiesCollCell", for: indexPath) as? AmmenitiesCollCell {
            
            let dict = arrAmmenities[indexPath.row]
            
            cell.lblTitle.text = dict.valueForString(key: "title")
            cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    

    
}

