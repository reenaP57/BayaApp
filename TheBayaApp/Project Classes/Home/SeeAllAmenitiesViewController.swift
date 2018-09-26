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
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!

    var arrAmmenities = [[String : AnyObject]]()
    var projectId = 0
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CAmeniriesScreenName)
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "Amenities"
        
        refreshControl.addTarget(self, action: #selector(pulltoRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        if #available(iOS 10.0, *) {
            collAmenities.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        self.loadAmenities(isRefresh: false)
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
        return CGSize(width: IS_iPad ?(CScreenWidth/4 - 50) : (CScreenWidth/3 - 20), height: IS_iPad ? CScreenWidth * (140/CScreenWidth) :  CScreenWidth * (120/CScreenWidth))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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


//MARK:-
//MARK:- API

extension SeeAllAmenitiesViewController {
    
    @objc func pulltoRefresh(){
        refreshControl.beginRefreshing()
        self.loadAmenities(isRefresh: true)
    }
    
    func loadAmenities(isRefresh : Bool) {
        
        if !isRefresh{
            activityLoader.startAnimating()
        }
        
        
        APIRequest.shared().getAmenities(projectId: projectId) { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.activityLoader.stopAnimating()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                
                
                if arrData.count > 0 {
                    if arrData.count != self.arrAmmenities.count {
                        self.arrAmmenities.removeAll()
                        for item in arrData {
                            self.arrAmmenities.append(item)
                        }
                    }
                }
                
                self.collAmenities.reloadData()
            }
        }
    }
    
}
