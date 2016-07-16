//
//  QueryLocationResultModel.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ObjectMapper

class QueryLocationResultModel: Mappable {

    
    var formattedAddress : String? // formatted_address
    var placeId : String? //place_id
    var lat : Double?
    var lng : Double?
    
    required init?(_ map: Map) {
        lat = 0
        lng = 0
        formattedAddress = ""
        placeId = ""
    }
    
    func mapping(map: Map) {
        formattedAddress <- map["formatted_address"]
        placeId <- map["place_id"]
        lat <- map["geometry.location.lat"]
        lng <- map["geometry.location.lng"]
    }

}

