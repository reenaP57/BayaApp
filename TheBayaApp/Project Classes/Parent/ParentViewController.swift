//
//  ParentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    
    //MARK:-
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MIKeyboardManager.shared.delegate = self
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
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:CFontAvenirLTStd(size: IS_iPad ? 22 : 17, type: .heavy).setUpAppropriateFont()!, NSAttributedStringKey.foregroundColor:ColorLightBlack]
        
        self.navigationController?.navigationBar.tintColor = ColorLightBlack
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_white")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "nav_back")
     
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        if self.view.tag == 100 {
            //...Hide NavigationBar
            self.navigationItem.hidesBackButton = true
            self.navigationController?.isNavigationBarHidden = true
            
        } else {
            //self.navigationController?.navigationBar.backgroundColor = ColorGreen

            if self.view.tag == 101 {
                //...Transparent
                 self.navigationController?.navigationBar.isTranslucent = true
                 self.navigationController?.navigationBar.backgroundColor = UIColor.clear

            } else {
                 self.navigationController?.navigationBar.isTranslucent = false
                 self.navigationController?.navigationBar.backgroundColor = ColorBGColor
                
               // self.navigationController?.navigationBar.backgroundColor = ColorBGColor
                
                self.navigationController?.navigationBar.barTintColor = ColorBGColor
            }
            
            self.navigationItem.hidesBackButton = false
            self.navigationController?.isNavigationBarHidden = false
        }
        
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
