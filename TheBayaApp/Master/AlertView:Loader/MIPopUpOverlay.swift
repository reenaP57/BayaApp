//
//  MIPopUpOverlay.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 05/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import UIKit

class MIPopUpOverlay: UIView {
    
    var shouldOutSideClick:Bool = false
    var type:MIPopUpPresentType = .none
    
    private static let popUpOverlay:MIPopUpOverlay? = {
        
//        guard let popUpOverlay = MIPopUpOverlay.viewFromXib as? MIPopUpOverlay else { return nil}
        
        guard let popUpOverlay = MIPopUpOverlay.viewFromNib(is_ipad: false) as? MIPopUpOverlay else { return nil}

        popUpOverlay.frame = CBounds
        
        return popUpOverlay
    }()
    
    static var shared:MIPopUpOverlay? {
        return popUpOverlay
    }
    
}

extension MIPopUpOverlay {
    
    enum MIPopUpPresentType {
        case none
        case center
        case bottom
        case topToCenter
        case bottomToCenter
        case leftToCenter
        case rightToCenter
    }
}

extension MIPopUpOverlay {
    
    @IBAction private func btnCloseTapped(sender:UIButton) {
        
        if shouldOutSideClick {
            
            if let popUpOverlaySubView = self.viewWithTag(151) {
                
                self.dismissPopUpOverlayView(view: popUpOverlaySubView, completionHandler: nil)
            }
        }
    }
}

extension MIPopUpOverlay {
    
    func presentPopUpOverlayView(view:UIView , completionHandler:popUpCompletionHandler?) {
        
        switch type {
            
        case .none:
            
            if let completionHandler = completionHandler {
                completionHandler()
            }
            
        case .center:
            
            view.center = CScreenCenter
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .bottom:
            
            view.CViewSetWidth(width: CScreenWidth)
            view.CViewSetY(y: CScreenHeight)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                view.CViewSetY(y: CScreenHeight - view.CViewHeight)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.05, options: .curveEaseIn, animations: {
                        
                        view.transform = CGAffineTransform(translationX: 0.0, y: 3.0)
                        
                    }, completion: { (completed) in
                        
                        if completed {
                            view.transform = .identity
                            
                            if let completionHandler = completionHandler {
                                completionHandler()
                            }
                        }
                    })
                }
            })
            
        case .topToCenter:
            
            view.CViewSetCenterX(x: CScreenCenterX)
            view.CViewSetCenterY(y: 0.0)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                
                view.CViewSetCenterY(y: CScreenCenterY)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .bottomToCenter:
            
            view.CViewSetCenterX(x: CScreenCenterX)
            view.CViewSetCenterY(y: CScreenHeight)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                
                view.CViewSetCenterY(y: CScreenCenterY)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
            
        case .leftToCenter:
            
            view.CViewSetCenterY(y: CScreenCenterY)
            view.CViewSetCenterX(x: 0.0)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                
                view.CViewSetCenterX(x: CScreenCenterX)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .rightToCenter:
            
            view.CViewSetCenterY(y: CScreenCenterY)
            view.CViewSetCenterX(x: CScreenWidth)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .layoutSubviews, animations: {
                
                view.CViewSetCenterX(x: CScreenCenterX)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
        }
    }
    
    func dismissPopUpOverlayView(view:UIView , completionHandler:popUpCompletionHandler?) {
        
        switch type {
            
        case .none:
            view.removeFromSuperview()
            self.removeFromSuperview()
            
            if let completionHandler = completionHandler {
                completionHandler()
            }
            
        case .center:
            
            UIView.animate(withDuration: 0.2, animations: {
                
                view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
            }, completion: { (completed) in
                
                if completed {
                    view.removeFromSuperview()
                    self.removeFromSuperview()
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .bottom:
            
            UIView.animate(withDuration: 0.3, animations: {
                
                view.CViewSetY(y: CScreenHeight)
                
            }, completion: { (completed) in
                
                if completed {
                    view.removeFromSuperview()
                    self.removeFromSuperview()
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .topToCenter:
            
            UIView.animate(withDuration: 0.20, animations: {
                
                view.CViewSetY(y: 0.0)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    UIView.animate(withDuration: 0.10, delay: 0.0, options: .layoutSubviews, animations: {
                        
                        view.CViewSetHeight(height: 0.0)
                        
                    }, completion: { (completed) in
                        
                        if completed {
                            view.removeFromSuperview()
                            self.removeFromSuperview()
                            
                            if let completionHandler = completionHandler {
                                completionHandler()
                            }
                        }
                    })
                }
            })
            
        case .bottomToCenter:
            
            UIView.animate(withDuration: 0.3, animations: {
                
                view.CViewSetY(y: CScreenHeight)
                
            }, completion: { (completed) in
                
                if completed {
                    view.removeFromSuperview()
                    self.removeFromSuperview()
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
            
        case .leftToCenter:
            
            UIView.animate(withDuration: 0.05, animations: {
                
                view.CViewSetX(x: 0.0)
                
            }, completion: { (completed) in
                
                if completed {
                    
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .layoutSubviews, animations: {
                        
                        view.CViewSetWidth(width: 0.0)
                        
                    }, completion: { (completed) in
                        
                        if completed {
                            view.removeFromSuperview()
                            self.removeFromSuperview()
                            
                            if let completionHandler = completionHandler {
                                completionHandler()
                            }
                        }
                    })
                }
            })
            
        case .rightToCenter:
            
            UIView.animate(withDuration: 0.3, animations: {
                
                view.CViewSetX(x: CScreenWidth)
                
            }, completion: { (completed) in
                
                if completed {
                    view.removeFromSuperview()
                    self.removeFromSuperview()
                    
                    if let completionHandler = completionHandler {
                        completionHandler()
                    }
                }
            })
        }
        
    }
    
}

