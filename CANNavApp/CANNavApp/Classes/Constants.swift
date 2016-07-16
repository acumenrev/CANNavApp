//
//  Constants.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit

class Constants: NSObject {
    // MARKS: NSUserDefaults
    
    enum Google : String {
        case API_KEY = "AIzaSyBs98V2OJK6hCXpvuEwd1rhq9Bk9mfqzKo"
    }

    enum Notification : String {
        case CanReachInternet  = "canReachInternet"
        
    }
    
    enum AlertTitle : String {
        case NoLocationService = "location service is disabled"
        case NoInternet = "network unavailable"
    }
    
    enum AlertMessage : String {
        case NoLocationService = "Please turn on Location Service in your device settings."
        case NoInternet = "The internet connection appears to be offline. Please check your network and try again."
    }
    
    
}
