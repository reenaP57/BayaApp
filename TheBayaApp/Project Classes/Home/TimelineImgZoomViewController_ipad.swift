//
//  TimelineImgZoomViewController_ipad.swift
//  TheBayaApp
//
//  Created by mac-00017 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimelineImgZoomViewController_ipad: ParentViewController {

    @IBOutlet fileprivate weak var collImg : UICollectionView!
    @IBOutlet fileprivate weak var pagevSlider : UIPageControl!

    var arrImg = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagevSlider.numberOfPages = arrImg.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

//MARK:-
//MARK:- Action

extension TimelineImgZoomViewController_ipad {
    
    @IBAction func btnCloseClicked(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:-
//MARK:- UICollectionView Delegate and Datasource

extension TimelineImgZoomViewController_ipad : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize  {
        
        return CGSize(width: collectionView.CViewWidth, height: collectionView.CViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeLineZoomImgCollCell_ipad", for: indexPath) as? TimeLineZoomImgCollCell_ipad {
            cell.imgVSlider.sd_setShowActivityIndicatorView(true)
            cell.imgVSlider.sd_setImage(with: URL(string: arrImg[indexPath.row]), placeholderImage: nil, options: .retryFailed, completed: nil)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = round(scrollView.contentOffset.x/scrollView.bounds.size.width)
        pagevSlider.currentPage = Int(page)
    }
}
