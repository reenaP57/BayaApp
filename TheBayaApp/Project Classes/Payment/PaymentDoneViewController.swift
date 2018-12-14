//
//  PaymentDoneViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PaymentDoneViewController: ParentViewController {

    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var imgVSuccess : UIImageView!
    @IBOutlet weak var vwContent : UIView!
    var circularView = UIView()

    var isFromOnlinePayment : Bool = false
    var paymentDetail = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //...Payment in Processing Mode
        self.title = CPaymentProcessing
        lblMsg.text = CMessagePaymentInProcessing
        self.imgVSuccess.isHidden = true
        self.makeOnlinePayment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOnlinePayment {
            //...If user come from rate screen that time it will be redirect on maintenance list screen
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
        }
    }
}


//MARK:-
//MARK:- Loader Function

extension PaymentDoneViewController {
    
    fileprivate func showCircularRing() {
        
        circularView.backgroundColor = .clear
        circularView.frame = CGRect(x: vwContent.CViewWidth/2 - 25, y: IS_iPad ? 83.0 : 45.0, width: 50.0, height: 50.0)
        
        let firstLayer = CAShapeLayer()
        firstLayer.frame = vwContent.bounds
        firstLayer.strokeColor = ColorGreenSelected.cgColor
        firstLayer.fillColor = nil
        firstLayer.lineWidth = 3.0
        
        let secondLayer = CAShapeLayer()
        secondLayer.frame = vwContent.bounds
        secondLayer.strokeColor = ColorGreenSelected.cgColor
        secondLayer.fillColor = nil
        secondLayer.lineWidth = 3.0
        
        circularView.layer.addSublayer(firstLayer)
        circularView.layer.addSublayer(secondLayer)
        
        circularView.translatesAutoresizingMaskIntoConstraints = false
        vwContent.addSubview(circularView)
        
        self.startAnimation(layer1: firstLayer, layer2: secondLayer)
    }
    
    fileprivate func startAnimation(layer1 : CAShapeLayer, layer2 : CAShapeLayer) {
        
        let radius = (min(circularView.CViewWidth,circularView.CViewHeight)/2.0) - (CGFloat((1/2.0)))
        layer1.path = UIBezierPath(arcCenter: circularView.CViewCenter, radius: radius, startAngle: -1.25, endAngle: 1.25, clockwise: true).cgPath
        layer2.path = UIBezierPath(arcCenter: circularView.CViewCenter, radius: radius, startAngle: 1.89, endAngle: 4.39, clockwise: true).cgPath
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2.0 * .pi
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.duration = 1.5
        
        DispatchQueue.main.async {
            self.circularView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        }
    }
    
    fileprivate func stopAnimation() {
        circularView.layer.removeAnimation(forKey: "rotationAnimation")
        circularView.removeFromSuperview()
    }
}


//MARK:-
//MARK:- Action

extension PaymentDoneViewController {
 
    @objc func btnBackClicked() {
        
        for vwController in (self.navigationController?.viewControllers)! {
            
            if vwController.isKind(of: PaymentScheduleViewController.classForCoder()){
                
                if let paymentScheduleVC = vwController as? PaymentScheduleViewController {
                    paymentScheduleVC.loadMilestoneList(showLoader: false)
                    self.navigationController?.popToViewController(paymentScheduleVC, animated: true)
                }
                break
            }
        }
    }
}

//MARK:-
//MARK:- API

extension PaymentDoneViewController {
    
    //...Online Payment
    func makeOnlinePayment() {
        
        self.showCircularRing()
        APIRequest.shared().makePayment(milestoneID: paymentDetail.valueForInt(key: "milestoneID"), amountTransactionID: paymentDetail.valueForString(key: "amountPaymentID"), taxTransactionID: paymentDetail.valueForString(key: "gstPaymentID")) { (response, error) in
            if response != nil {
                
                self.stopAnimation()
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    
                    let msg = metaData.valueForString(key: CJsonMessage)
                    self.imgVSuccess.isHidden = false

                    switch metaData.valueForInt(key: CJsonStatus) {
                    case CStatusOne :  //Fail Payment
                        self.title = CPaymentFail
                        self.lblMsg.text = msg
                        self.imgVSuccess.hide(byHeight: true)
                    case CStatusZero :  // Success Payment
                        self.title = CPaymentDone
                        self.lblMsg.text = msg
                        self.imgVSuccess.hide(byHeight: false)
                    default: // Other Error
                        self.showAlertView(msg, completion: nil)
                    }
                }
            }
        }
    }
}
