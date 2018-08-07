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
    case blackItalic
    case bold
    case boldItalic
    case light
    case extraLight
    case extraLightItalic
    case italic
    case lightItalic
    case thin
    case thinItalic
    case extraBold
    case extraBoldItalic
    case semibold
    case semiboldItalic
    case meduim
    case meduimItalic
    case regular
}

func CFontPoppins(size: CGFloat, type: CFontType) -> UIFont {
    switch type {
    case .black:
        return UIFont.init(name: "Poppins-Black", size: size)!
        
    case .blackItalic:
        return UIFont.init(name: "Poppins-BlackItalic", size: size)!
    
    case .bold:
        return UIFont.init(name: "Poppins-Bold", size: size)!
        
    case .boldItalic:
        return UIFont.init(name: "Poppins-BoldItalic", size: size)!
    
    case .extraBold:
        return UIFont.init(name: "Poppins-ExtraBold", size: size)!
        
    case .extraBoldItalic:
        return UIFont.init(name: "Poppins-ExtraBoldItalic", size: size)!
        
    case .extraLight:
        return UIFont.init(name: "Poppins-ExtraLight", size: size)!

    case .extraLightItalic:
        return UIFont.init(name: "Poppins-ExtraLightItalic", size: size)!

    case .italic:
        return UIFont.init(name: "Poppins-Italic", size: size)!
        
    case .light:
        return UIFont.init(name: "Poppins-Light", size: size)!

    case .lightItalic:
        return UIFont.init(name: "Poppins-LightItalic", size: size)!

    case .meduim:
        return UIFont.init(name: "Poppins-Medium", size: size)!

    case .meduimItalic:
        return UIFont.init(name: "Poppins-MediumItalic", size: size)!

    case .regular:
        return UIFont.init(name: "Poppins-Regular", size: size)!
        
    case .semibold:
        return UIFont.init(name: "Poppins-SemiBold", size: size)!

    case .semiboldItalic:
        return UIFont.init(name: "Poppins-SemiBoldItalic", size: size)!

    case .thin:
        return UIFont.init(name: "Poppins-Thin", size: size)!

    case .thinItalic:
        return UIFont.init(name: "Poppins-ThinItalic", size: size)!
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
let ColorAppDefault          = CRGB(r: 138, g: 181, b: 136)
let ColorGreen          = CRGB(r: 132, g: 154, b: 164)


//MARK:- UIStoryboard
let CStoryboardMain = UIStoryboard(name: "Main", bundle: nil)

//MARK:-
//MARK:- Application Language
let CLanguageEnglish           = "en"
let CLanguageArabic            = "ar"

func CLocalize(text: String) -> String {
    return Localization.sharedInstance.localizedString(forKey: text , value: text)
}



//MARK:-
//MARK:- Other
let CComponentJoinedString          = ", "

let CAccountTypeNormal       = 0
let CAccountTypeFacebook     = 1
let CAccountTypeGoogle       = 2
let CAccountTypeInstagram    = 3

