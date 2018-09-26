//
//  MIGoogleAnalytics.swift
//  TheBayaApp
//
//  Created by mac-00017 on 26/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation

class MIGoogleAnalytics: NSObject {
    
    
    private static var googleAnalytics : MIGoogleAnalytics = {
       
        let googleAnalytics = MIGoogleAnalytics()
        return googleAnalytics
    }()
    
    static func shared() -> MIGoogleAnalytics {
        return googleAnalytics
    }
    
    func configureGoogleAnalytics() {
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        
        gai.tracker(withTrackingId: CTrackingID)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
    }
    
    func trackScreenNameForGoogleAnalytics(screenName : String) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func trackCustomEvent(buttonName : String) {
        
        let tracker = GAI.sharedInstance().defaultTracker
        
        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Button Interaction", action: "\(buttonName) is clicked", label: "Button Click", value: nil).build() as [NSObject : AnyObject])
    }
    
}




