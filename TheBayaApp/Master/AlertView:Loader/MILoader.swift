//
//  MILoader.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 12/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

class MILoader {
    
    private init() {}
    
    private static let miLoader:MILoader = {
        let miLoader = MILoader()
        return miLoader
    }()
    
    static var shared:MILoader {
        return miLoader
    }
    
    var isAnimating:Bool = false
    fileprivate var type:MILoaderType = .activityIndicator
    
    fileprivate static var circularLineWidth = 3.0
    fileprivate static var animationDuration = 1.5
    
}

extension MILoader {
    
    enum MILoaderType {
        case activityIndicator
        case activityIndicatorWithMessage
        case circularRing
        case animatedGIF
    }
    
}

extension MILoader {
    
    fileprivate static let transparentOverlayView:UIView = {
        
        let transparentOverlayView = UIView()
        transparentOverlayView.frame = CBounds
        transparentOverlayView.backgroundColor = CRGBA(r: 0, g: 0, b: 0, a: 0.4)
        return transparentOverlayView
    }()
    
    func setTransparentOverlayViewBgColor(bgColor:UIColor?) {
        MILoader.transparentOverlayView.backgroundColor = bgColor
    }
    
    func setTransparentOverlayViewAlpha(alpha:CGFloat) {
        
        if var rgba = MILoader.transparentOverlayView.backgroundColor?.getRGB() {
            
            rgba.a = alpha
            
            MILoader.transparentOverlayView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
        }
    }
}

extension MILoader {
    
    fileprivate static let containView:UIView = {
        
        let containView = UIView()
        containView.backgroundColor = ColorWhite
        containView.layer.cornerRadius = 4.0
        containView.translatesAutoresizingMaskIntoConstraints = false
        return containView
    }()
    
    func setContainViewCornerRadius(cornerRadius:CGFloat) {
        MILoader.containView.layer.cornerRadius = cornerRadius
    }
    
    func setContainViewBgColor(bgColor:UIColor?) {
        MILoader.containView.backgroundColor = bgColor
    }
    
    func setContainViewAlpha(alpha:CGFloat) {
        
        if var rgba = MILoader.containView.backgroundColor?.getRGB() {
            
            rgba.a = alpha
            
            MILoader.containView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
        }
        
    }
}

extension MILoader {
    
    fileprivate static let activityIndicator:UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    
    func setActivityIndicatorStyle(style:UIActivityIndicatorViewStyle) {
        MILoader.activityIndicator.activityIndicatorViewStyle = style
    }
    
    func setActivityIndicatorColor(color:UIColor?) {
        MILoader.activityIndicator.color = color
    }
    
    func setActivityIndicatorTintColor(tintColor:UIColor) {
        MILoader.activityIndicator.tintColor = tintColor
    }
    
    func setActivityIndicatorBgColor(bgColor:UIColor?) {
        MILoader.activityIndicator.backgroundColor = bgColor
    }
    
}

extension MILoader {
    
    fileprivate static let lblMessage:UILabel = {
        
        let lblMessage = UILabel()
        lblMessage.textAlignment = .center
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .clear
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        return lblMessage
    }()
    
    func setLblMessageTextAlignment(alignment:NSTextAlignment) {
        MILoader.lblMessage.textAlignment = alignment
    }
    
    func setLblMessageFont(font:UIFont) {
        MILoader.lblMessage.font = font
    }
    
    func setLblMessageTextColor(textColor:UIColor) {
        MILoader.lblMessage.textColor = textColor
    }
    
    fileprivate func setLblMessageText(message:String?) {
        MILoader.lblMessage.text = message
    }
}

extension MILoader {
    
    fileprivate static let circularView:UIView = {
        
        let circularView = UIView()
        circularView.backgroundColor = .clear
        
        circularView.layer.addSublayer(MILoader.firstLayer)
        circularView.layer.addSublayer(MILoader.secondLayer)
        
        circularView.translatesAutoresizingMaskIntoConstraints = false
        
        return circularView
    }()
    
    fileprivate static let firstLayer:CAShapeLayer = {
        
        let firstLayer = CAShapeLayer()
        firstLayer.frame = CBounds
        firstLayer.strokeColor = ColorGreenSelected.cgColor
        firstLayer.fillColor = nil
        firstLayer.lineWidth = CGFloat(MILoader.circularLineWidth)
        return firstLayer
    }()
    
    fileprivate static let secondLayer:CAShapeLayer = {
        
        let secondLayer = CAShapeLayer()
        secondLayer.frame = CBounds
        secondLayer.strokeColor = ColorGreenSelected.cgColor
        secondLayer.fillColor = nil
        secondLayer.lineWidth = CGFloat(MILoader.circularLineWidth)
        return secondLayer
    }()
    
    fileprivate static let rotationAnimation:CAAnimation = {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2.0 * .pi
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.duration = MILoader.animationDuration
        return rotationAnimation
    }()
    
    func setCircularRingBorderColor(color:UIColor?) {
        MILoader.firstLayer.strokeColor = color?.cgColor
        MILoader.secondLayer.strokeColor = color?.cgColor
    }
    
    func setCircularRingLineWidth(lineWidth:Double) {
        MILoader.circularLineWidth = lineWidth
    }
    
    func setCircularRingAnimationDuration(duration:Double) {
        MILoader.animationDuration = duration
    }
    
}

extension MILoader {
    
    fileprivate static let gifImgView:UIImageView =
    {
        let gifImgView = UIImageView()
        gifImgView.backgroundColor = UIColor.white
        gifImgView.translatesAutoresizingMaskIntoConstraints = false
        gifImgView.image = UIImage.gif(name: "Loading")
        gifImgView.layer.masksToBounds = true
        return gifImgView
    }()
    
}

extension MILoader {
    
    fileprivate func startAnimating() {
        MILoader.shared.isAnimating = true
        MILoader.activityIndicator.startAnimating()
    }
    
    fileprivate func stopAnimating() {
        MILoader.shared.isAnimating = false
        MILoader.activityIndicator.stopAnimating()
        MILoader.activityIndicator.removeFromSuperview()
    }
}

extension MILoader {
    
    fileprivate func showActivityIndicator() {
        
        appDelegate.window.addSubview(MILoader.activityIndicator)
        self.resizeActivityIndicator()
        self.startAnimating()
    }
    
    private func resizeActivityIndicator() {
        
        NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: appDelegate.window, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive  = true
        
        NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: appDelegate.window, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive  = true
    }
    
    fileprivate func hideActivityIndicator() {
        self.stopAnimating()
    }
    
}

extension MILoader {
    
    fileprivate func showActivityIndicatorWithMessage(message:String?) {
        
        MILoader.shared.setLblMessageText(message: message)
        
        appDelegate.window.addSubview(MILoader.transparentOverlayView)
        MILoader.transparentOverlayView.addSubview(MILoader.containView)
        MILoader.containView.addSubview(MILoader.activityIndicator)
        MILoader.containView.addSubview(MILoader.lblMessage)
        
        self.resizeActivityIndicatorWithMessage()
        self.startAnimating()
    }
    
    private func resizeActivityIndicatorWithMessage() {
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerX, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerY, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        let topOfActivityIndicator = NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .top, relatedBy: .equal, toItem: MILoader.containView, attribute: .top, multiplier: 1.0, constant: 25.0)
        
        topOfActivityIndicator.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 1000 : 750))
        topOfActivityIndicator.isActive = true
        
        let leadingOfActivityIndicator = NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .leading, relatedBy: .equal, toItem: MILoader.containView, attribute: .leading, multiplier: 1.0, constant: 25.0)
        
        leadingOfActivityIndicator.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 750 : 1000))
        leadingOfActivityIndicator.isActive = true
        
        let CenterYOfActivityIndicator = NSLayoutConstraint(item: MILoader.activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        CenterYOfActivityIndicator.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 750 : 1000))
        CenterYOfActivityIndicator.isActive = true
        
        MILoader.activityIndicator.layoutIfNeeded()
        
        NSLayoutConstraint(item: MILoader.lblMessage, attribute: .centerX, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        let topOfLblMessage =  NSLayoutConstraint(item: MILoader.lblMessage, attribute: .top, relatedBy: .equal, toItem: MILoader.activityIndicator, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        
        topOfLblMessage.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 1000 : 750))
        topOfLblMessage.isActive = true
        
        let leadingOfLblMessage =  NSLayoutConstraint(item: MILoader.lblMessage, attribute: .leading, relatedBy: .equal, toItem: MILoader.containView, attribute: .leading, multiplier: 1.0, constant: 15.0)
        
        leadingOfLblMessage.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 1000 : 750))
        leadingOfLblMessage.isActive = true
        
        let bottomOfLblMessage =  NSLayoutConstraint(item: MILoader.lblMessage, attribute: .bottom, relatedBy: .equal, toItem: MILoader.containView, attribute: .bottom, multiplier: 1.0, constant: -15.0)
        
        bottomOfLblMessage.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue((MILoader.lblMessage.text != nil) ? 1000 : 749))
        bottomOfLblMessage.isActive = true
        
        MILoader.lblMessage.layoutIfNeeded()
    }
    
    fileprivate func hideActivityIndicatorWithMessage() {
        self.stopAnimating()
        MILoader.transparentOverlayView.removeAllSubviews()
        MILoader.transparentOverlayView.removeFromSuperview()
    }
    
}

extension MILoader {
    
    fileprivate func showCircularRing() {
        
        appDelegate.window.addSubview(MILoader.transparentOverlayView)
        MILoader.transparentOverlayView.addSubview(MILoader.containView)
        MILoader.containView.addSubview(MILoader.circularView)
        
        self.resizeCircularRing()
        self.startCircularRingAnimation()
    }
    
    private func resizeCircularRing() {
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerX, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerY, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true
        
        MILoader.containView.layoutIfNeeded()
        
        NSLayoutConstraint(item: MILoader.circularView, attribute: .centerX, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.circularView, attribute: .centerY, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.circularView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.circularView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0).isActive = true
        
        MILoader.circularView.layoutIfNeeded()
    }
    
    private func startCircularRingAnimation() {
        
        let radius = (min(MILoader.circularView.CViewWidth, MILoader.circularView.CViewHeight)/2.0) - (CGFloat((MILoader.circularLineWidth/2.0)))
        
        MILoader.firstLayer.path = UIBezierPath(arcCenter: MILoader.circularView.CViewCenter, radius: radius, startAngle: -1.25, endAngle: 1.25, clockwise: true).cgPath
        
        MILoader.secondLayer.path = UIBezierPath(arcCenter: MILoader.circularView.CViewCenter, radius: radius, startAngle: 1.89, endAngle: 4.39, clockwise: true).cgPath
        
        DispatchQueue.main.async {
            
            MILoader.circularView.layer.add(MILoader.rotationAnimation, forKey: "rotationAnimation")
            MILoader.shared.isAnimating = true
        }
    }
    
    fileprivate func hideCircularRing() {
        MILoader.circularView.layer.removeAnimation(forKey: "rotationAnimation")
        MILoader.shared.isAnimating = false
        MILoader.transparentOverlayView.removeAllSubviews()
        MILoader.transparentOverlayView.removeFromSuperview()
    }
    
}

extension MILoader {
    
    func setGIFName(name:String) {
        MILoader.gifImgView.loadGif(name: name)
    }
    
    fileprivate func showGifLoader() {
        
        appDelegate.window.addSubview(MILoader.transparentOverlayView)
        MILoader.transparentOverlayView.addSubview(MILoader.containView)
        MILoader.containView.addSubview(MILoader.gifImgView)
        
        self.resizeGifLoader()
        MILoader.shared.isAnimating = true
    }
    
    private func resizeGifLoader() {
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerX, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .centerY, relatedBy: .equal, toItem: MILoader.transparentOverlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.containView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0).isActive = true
        
        MILoader.containView.layoutIfNeeded()

        
        NSLayoutConstraint(item: MILoader.gifImgView, attribute: .centerX, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.gifImgView, attribute: .centerY, relatedBy: .equal, toItem: MILoader.containView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MILoader.gifImgView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100).isActive = true
        
        NSLayoutConstraint(item: MILoader.gifImgView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100).isActive = true
        MILoader.gifImgView.layoutIfNeeded()
        
        MILoader.gifImgView.layer.cornerRadius = MILoader.gifImgView.frame.size.height/2
        MILoader.containView.layer.cornerRadius = MILoader.containView.frame.size.height/2
    }
    
    fileprivate func hideGifLoader() {
        MILoader.shared.isAnimating = false
        MILoader.transparentOverlayView.removeAllSubviews()
        MILoader.transparentOverlayView.removeFromSuperview()
    }
    
}

extension MILoader {
    
    func showLoader(type:MILoaderType , message:String?) {
        
        MILoader.shared.type = type
        
        switch type {
            
        case .activityIndicator:
            self.showActivityIndicator()
            
        case .activityIndicatorWithMessage:
            self.showActivityIndicatorWithMessage(message: message)
            
        case .circularRing:
            self.showCircularRing()
            
        case .animatedGIF:
            self.showGifLoader()
            
        }
    }
    
    func hideLoader() {
        
        switch MILoader.shared.type {
            
        case .activityIndicator:
            self.hideActivityIndicator()
            
        case .activityIndicatorWithMessage:
            self.hideActivityIndicatorWithMessage()
            
        case .circularRing:
            self.hideCircularRing()
            
        case .animatedGIF:
            self.hideGifLoader()
            
        }
    }
    
}
