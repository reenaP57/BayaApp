//
//  TutorialViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TutorialViewController: ParentViewController {

    @IBOutlet fileprivate weak var collTutorial : UICollectionView!
    @IBOutlet fileprivate weak var pageVSlider : UIPageControl!
    @IBOutlet fileprivate weak var btnSkip : UIButton! {
        didSet{
            btnSkip.layer.borderWidth = 1
            btnSkip.layer.borderColor =  ColorGray.cgColor
        }
    }
    @IBOutlet fileprivate weak var btnNext : UIButton!

    let arrTutorial = [["img" : "tutorial1", "title" :"Timeline", "desc" : "See the updates for all our projects with construction photos \n\n View the percentage completion of each project \n\n Easy one tap contact to get in touch with the sales team \n\n Subscribe to projects to receive update notifications"],
                       ["img" : "tutorial2", "title" :"Project Details", "desc" : "View all The Baya Company projects and the details \n\n Project overviews, amenities, specifications,location advantage and more \n\n Easy one tap contact to get in touch with the sales team \n\n Subscribe to specific projects to receive update notifications"],
                       ["img" : "tutorial3", "title" :"Schedule A Visit", "desc" : "Schedule a site visit for our projects \n\n Select up to 3 preferred date & time slots \n\n Rate your site visits to improve the overall experience"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK:-
//MARK:- Action

extension TutorialViewController {
    
    @IBAction fileprivate func btnSkipClicked (sender : UIButton) {
        
        appDelegate.initLoginViewController()
    }
    
    @IBAction fileprivate func btnNextClicked (sender : UIButton) {
        
        let index = round(collTutorial.contentOffset.x/collTutorial.bounds.size.width)
        let indexPath = IndexPath(item: Int(index)+1, section: 0)
        
        if Int(index) == 2 {
            appDelegate.initLoginViewController()
    
        } else {
            collTutorial.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        }
    }
}



//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TutorialViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: CScreenWidth, height: collectionView.CViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollCell", for: indexPath) as? TutorialCollCell {
            
            let dict = arrTutorial[indexPath.row]
            
            cell.imgVTutorial.image = UIImage(named: dict.valueForString(key: "img"))
            cell.lblTitle.text = dict.valueForString(key: "title")
            cell.lblDesc.text = dict.valueForString(key: "desc")
            
            return cell
        }
        
        return UICollectionViewCell()
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        pageVSlider.currentPage = Int(page)
        
        btnNext.setTitle(Int(pageVSlider.currentPage) == 2 ? "DONE" : "NEXT" , for: .normal)
        btnSkip.isHidden = pageVSlider.currentPage == 2
    }
}



