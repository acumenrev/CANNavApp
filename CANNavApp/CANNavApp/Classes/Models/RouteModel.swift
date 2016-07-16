//
//  RouteModel.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ObjectMapper

class LegModel : Mappable {
    
    var startAddress : String?
    var endAddress : String?
    var distance : String?
    var duration : String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        startAddress <- map["start_address"]
        endAddress <- map["end_address"]
        distance <- map["distance.text"]
        duration <- map["duration.text"]
    }
}

class RouteModel: Mappable {
    
    var paths : String?
    var legs : Array<LegModel>?
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        paths <- map["overview_polyline.points"]
        legs <- (map["legs"], ArrayMapperTransformation<LegModel>())
    }

}
