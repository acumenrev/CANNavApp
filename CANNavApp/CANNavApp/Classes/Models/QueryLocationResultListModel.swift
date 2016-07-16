//
//  QueyLocationResultListModel.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ObjectMapper

class QueryLocationResultListModel: Mappable {
    
    var status : String?
    var results : Array<QueryLocationResultModel>?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        results <- (map["results"], ArrayMapperTransformation<QueryLocationResultModel>())
    }
    
}
