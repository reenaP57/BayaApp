//
//  ApplicationConstants.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit


//MARK:- Fonts
enum CFontType:Int {
    
   case black
   case blackOblique
   case book
   case bookOblique
   case heavy
   case heavyOblique
   case light
   case lightOblique
   case medium
   case mediumOblique
   case roman
}


func CFontAvenirLTStd(size: CGFloat, type: CFontType) -> UIFont {
    switch type {
    case .black:
        return UIFont.init(name: "AvenirLTStd-Black", size: size)!
        
    case .blackOblique:
        return UIFont.init(name: "AvenirLTStd-BlackOblique.otf", size: size)!
    
    case .book:
        return UIFont.init(name: "AvenirLTStd-Book", size: size)!
        
    case .bookOblique:
        return UIFont.init(name: "AvenirLTStd-BookOblique", size: size)!
    
    case .heavy:
        return UIFont.init(name: "AvenirLTStd-Heavy", size: size)!
        
    case .heavyOblique:
        return UIFont.init(name: "AvenirLTStd-HeavyOblique", size: size)!
        
    case .light:
        return UIFont.init(name: "AvenirLTStd-Light", size: size)!

    case .lightOblique:
        return UIFont.init(name: "AvenirLTStd-LightOblique", size: size)!

    case .medium:
        return UIFont.init(name: "AvenirLTStd-Medium", size: size)!
        
    case .mediumOblique:
        return UIFont.init(name: "AvenirLTStd-MediumOblique", size: size)!

    case .roman:
        return UIFont.init(name: "AvenirLTStd-Roman", size: size)!

    }
}



//MARK:- Notification Constants
let NotificationDidUpdateUserDetail     = "NotificationDidUpdateUserDetail"




//MARK:- UserDefaults
let UserDefaultiPadAuthCode               = "UserDefaultiPadAuthCode"
let UserDefaultGeneralDataLoaded          = "UserDefaultGeneralDataLoaded"




//MARK:- Color

let ColorBlack          = CRGB(r: 0, g: 0, b: 0)
let ColorWhite          = CRGB(r: 255, g: 255, b: 255)
let ColorAppDefault     = CRGB(r: 138, g: 181, b: 136)
let ColorGreen          = CRGB(r: 132, g: 154, b: 164)
let ColorLightBlack     = CRGB(r: 51, g: 51, b: 51)
let ColorBGColor        = CRGB(r: 242, g: 248, b: 252)
let ColorGray           = CRGB(r: 170, g: 170, b: 170)
let ColorValidation     = CRGB(r: 255, g: 39, b: 54)
let ColorShadow         = CRGBA(r: 0, g: 0, b: 0, a: 0.1) //(r: 240.0, g: 240.0, b: 240.0)
let ColorGradient1Background =  CRGB(r: 255, g: 203, b: 82)
let ColorGradient2Background =  CRGB(r: 255, g: 123, b: 2)
let ColorProgressGradient1   =  CRGB(r: 75, g: 183, b: 71)
let ColorProgressGradient2   =  CRGB(r: 170, g: 211, b: 94)
let ColorUnreadNotification  =  CRGB(r: 222, g: 255, b: 220)
let ColorDisableTextField    =  CRGB(r: 220, g: 220, b: 220)
let ColorGreenSelected       =  CRGB(r: 66, g: 173, b: 62)

//MARK:- UIStoryboard
let CStoryboardMain = UIStoryboard(name: IS_iPad ? "Main_ipad" : "Main", bundle: nil)
let CStoryboardLRF  = UIStoryboard(name: IS_iPad ? "LRF_ipad" : "LRF", bundle: nil)
let CStoryboardSetting  = UIStoryboard(name: IS_iPad ? "Main_ipad" : "Main", bundle: nil) //UIStoryboard(name: IS_iPad ? "Setting_ipad" : "Setting", bundle: nil)
let CStoryboardProfile  = UIStoryboard(name: IS_iPad ? "Main_ipad" : "Main", bundle: nil) //UIStoryboard(name: IS_iPad ? "Profile_ipad" : "Profile", bundle: nil)



func CLocalize(text: String) -> String {
    return Localization.sharedInstance.localizedString(forKey: text , value: text)
}



