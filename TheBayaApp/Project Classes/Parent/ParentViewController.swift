//
//  ParentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController //, UIGestureRecognizerDelegate
{
    
    
    //MARK:-
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // MIKeyboardManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewAppearance()
        MIKeyboardManager.shared.enableKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignKeyboard()
        MIKeyboardManager.shared.disableKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -
    // MARK: - Keyboard Appear/Disappear Methods , Just override it.
    func miKeyboardWillShow(notification: Notification, keyboardHeight: CGFloat) {}
    func miKeyboardDidHide(notification: Notification) {}
    
    
    //MARK:-
    //MARK:- General Method
    
    fileprivate func setupViewAppearance() {
        
        //....Generic Navigation Setup
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontAvenir(size: 19, type: .heavy).setUpAppropriateFont()!, NSAttributedStringKey.foregroundColor:ColorLightBlack]
        
        self.navigationController?.navigationBar.tintColor = ColorLightBlack
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
      //  self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        /*   self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_back_white")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "nav_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil) */
 
        
        let vwBackBtn = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        let imgBack = UIImageView.init(frame: CGRect(x: 0, y: 10, width: 13, height: 22))
        imgBack.image = UIImage(named: "nav_back")

        let backBtn = UIButton.init(frame: vwBackBtn.frame)
        backBtn.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)

        vwBackBtn.addSubview(imgBack)
        vwBackBtn.addSubview(backBtn)
        
        let backButton = UIBarButtonItem.init(customView: vwBackBtn)
        self.navigationItem.leftBarButtonItem = backButton

        if self.view.tag == 100 {
            //...Hide NavigationBar
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = true
            
        } else {
            //self.navigationController?.navigationBar.backgroundColor = ColorGreen

            self.navigationItem.hidesBackButton = false
            self.navigationController?.isNavigationBarHidden = false
            
            if self.view.tag == 101 {
                //...Transparent
                 self.navigationController?.navigationBar.isTranslucent = true
                 self.navigationController?.navigationBar.backgroundColor = UIColor.clear

            } else if self.view.tag == 102 {
                //...Transparent and Hide leftBarButton
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.backgroundColor = UIColor.clear
                self.navigationItem.leftBarButtonItem = nil
          
            } else {
                 self.navigationController?.navigationBar.isTranslucent = false
                 self.navigationController?.navigationBar.backgroundColor = ColorBGColor
                
               // self.navigationController?.navigationBar.backgroundColor = ColorBGColor
                
                self.navigationController?.navigationBar.barTintColor = ColorBGColor
            }
        }
    }
    
//    fileprivate func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if(self.navigationController!.viewControllers.count > 1){
//            return true
//        }
//        return false
//    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func resignKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


// MARK: -
// MARK: - MIKeyboardManagerDelegate Methods.
extension ParentViewController : MIKeyboardManagerDelegate {
    
    func keyboardWillShow(notification: Notification, keyboardHeight: CGFloat) {
        self.miKeyboardWillShow(notification: notification, keyboardHeight: keyboardHeight)
    }
    
    func keyboardDidHide(notification: Notification) {
        self.miKeyboardDidHide(notification: notification)
    }
}

//MARK:-
//MARK:-

extension ParentViewController {
    
    func setCurrencyFormat(amount : Float) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        let numberString = "\(amount)" //"\(NSNumber(value: amount))"
        let numberComponent = numberString.components(separatedBy :".")
        
        //...Check here if value after point is greter than 50 than amount will be increase 1 other wise amount will be as it is and remove value after point.
        if numberComponent.count != 0 {
            if let integerNumber = Int(numberComponent [0]) {
                if numberComponent.count > 1 {
                    if let fractionalNumber = Int(numberComponent [1]) {
                        if fractionalNumber > 50 {
                            return formatter.string(from: NSNumber(value: integerNumber+1))!
                        } else {
                            return formatter.string(from: NSNumber(value: integerNumber))!
                        }
                    }
                }
            }
        }
        
        return formatter.string(from: NSNumber(value: amount))!
    }
}
