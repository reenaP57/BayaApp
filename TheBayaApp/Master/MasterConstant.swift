//
//  MasterConstant.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 05/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

let CMainScreen = UIScreen.main
let CBounds = CMainScreen.bounds

let CScreenSize = CBounds.size
let CScreenWidth = CScreenSize.width
let CScreenHeight = CScreenSize.height

let CScreenOrigin = CBounds.origin
let CScreenX = CScreenOrigin.x
let CScreenY = CScreenOrigin.y

let CScreenCenter = CGPoint(x: CScreenWidth/2.0, y: CScreenHeight/2.0)
let CScreenCenterX = CScreenCenter.x
let CScreenCenterY = CScreenCenter.y

let CSharedApplication = UIApplication.shared
let appDelegate = CSharedApplication.delegate as! AppDelegate
var CTopMostViewController:UIViewController
{
    get { return CSharedApplication.topMostViewController }
    set{}
}

let CUserDefaults = UserDefaults.standard

let CCurrentDevice = UIDevice.current
let CUserInterfaceIdiom = CCurrentDevice.userInterfaceIdiom
let IS_iPhone = CUserInterfaceIdiom == .phone
let IS_iPad = CUserInterfaceIdiom == .pad
let IS_TV = CUserInterfaceIdiom == .tv

let COrientation = CCurrentDevice.orientation
let IS_Portrait = COrientation.isPortrait
let IS_Landscape = COrientation.isLandscape

let CSystemVersion = CCurrentDevice.systemVersion
let IS_iOS7 = CSystemVersion.toDouble?.toInt == 7
let IS_iOS8 = CSystemVersion.toDouble?.toInt == 8
let IS_iOS9 = CSystemVersion.toDouble?.toInt == 9
let IS_iOS10 = CSystemVersion.toDouble?.toInt == 10
let IS_iOS11 = CSystemVersion.toDouble?.toInt == 11

let IS_SIMULATOR    = (TARGET_IPHONE_SIMULATOR == 1)
let IS_iPhone_4 = CScreenHeight == 480
let IS_iPhone_5 = CScreenHeight == 568
let IS_iPhone_6 = CScreenHeight == 667
let IS_iPhone_6_Plus = CScreenHeight == 736
let IS_iPhone_X = CScreenHeight == 812

let CMainBundle = Bundle.main
let CBundleIdentifier = CMainBundle.bundleIdentifier
let CBundleInfoDictionary = CMainBundle.infoDictionary
let CVersionNumber = CBundleInfoDictionary?.valueForString(key: "CFBundleShortVersionString")
let CBuildNumber = CBundleInfoDictionary?.valueForString(key: "CFBundleVersion")
let CApplicationName = CBundleInfoDictionary?.valueForString(key: "CFBundleDisplayName")

func CRGB(r:CGFloat , g:CGFloat , b:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func CRGBA(r:CGFloat , g:CGFloat , b:CGFloat , a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}



let GCDMainThread                   = DispatchQueue.main

let GCDBackgroundThread             = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)

let GCDBackgroundThreadLowPriority  = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low)

let GCDBackgroundThreadHighPriority = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
