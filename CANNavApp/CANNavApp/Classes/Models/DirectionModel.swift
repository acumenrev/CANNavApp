//
//  DirectionModel.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ObjectMapper

class DirectionModel: Mappable {

    var routes : Array<RouteModel>?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        routes <- (map["routes"], ArrayMapperTransformation<RouteModel>())
    }
}
