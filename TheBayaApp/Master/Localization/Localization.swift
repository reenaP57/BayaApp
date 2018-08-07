//
//  Localization.swift
//  CollectMee
//
//  Created by mac-0007 on 13/12/17.
//  Copyright © 2017 mac-0007. All rights reserved.
//

import Foundation

func LocalizationSetLanguage(language: String) {
    Localization.sharedInstance.setLanguage(language)
}

//func CLocalize(text: String) -> String {
//    return Localization.sharedInstance.localizedString(forKey: text , value: text)
//}

class Localization: NSObject {
    static let sharedInstance = Localization()
    private override init() {} // This prevents others from using the default '()' initializer for this class.
    static var bundle  = Bundle.main
    
    func localizedString(forKey key: String, value comment: String) -> String {
        return Localization.bundle.localizedString(forKey: key, value: comment, table: nil)
    }
    
    func setLanguage(_ lang: String) {
        print("preferredLang: \(lang)")
        let path: String? = Bundle.main.path(forResource: lang, ofType: "lproj")
        if path == nil {
            resetLocalization(lang) //in case the language does not exists
        } else {
            Localization.bundle = Bundle(path: path ?? "")!
        }
        
        setAppleLanguage(lang)
    }
    
    func getLanguage() -> String {
        let languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [Any]
        let preferredLang = languages?[0] as? String
        return preferredLang?.components(separatedBy: "-").first ?? ""
    }
    
    func resetLocalization(_ lang:String) {
        if let path = Bundle.main.path(forResource: "Base", ofType: "lproj"), let bundle = Bundle(path: path) {
            Localization.bundle = bundle
        } else {
            Localization.bundle = Bundle.main
        }
    }
    
    
    //MARK:-
    //MARK:- PRIVATE
    private func setAppleLanguage(_ lang: String) {
        var languages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]
        let cLangReg = languageWithCurrentRegion(lang)
        var isContain = false
        
        for (index, lang) in (languages?.enumerated())! {
            if lang == cLangReg {
                isContain = true
                languages = rearrange(array: languages!, fromIndex: index, toIndex: 0)
            }
        }
        
        if !isContain {
            languages?.insert(cLangReg!, at: 0)
        }
        
        UserDefaults.standard.set(languages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    private func languageWithCurrentRegion(_ lang:String) -> String? {
        let currentRegion = (NSLocale.current.regionCode != nil) ? ((NSLocale.current.regionCode?.isBlank)! ? "" : "-\(NSLocale.current.regionCode!)") : ""
        
        return "\(lang)\(currentRegion)"
    }
    
    private func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T> {
        var arr = array
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        
        return arr
    }
}
