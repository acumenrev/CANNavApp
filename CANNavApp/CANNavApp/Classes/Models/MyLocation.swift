//
//  MyLocation.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import CoreLocation

class MyLocation: NSObject {
    
    var mLocationCoordinate : CLLocationCoordinate2D?
    var mLocationName : String?
    
    init(location coordinate : CLLocationCoordinate2D, name locationName : String) {
        super.init()
        self.mLocationCoordinate = coordinate
        self.mLocationName = locationName
    }
}
