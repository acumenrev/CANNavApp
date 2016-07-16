//
//  ArrayMapperTransformation.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ObjectMapper

class ArrayMapperTransformation <T where T:Mappable>: TransformType {
    typealias Object = Array<T>
    typealias JSON = Array<AnyObject>
    
    let mapper = Mapper<T>()
    
    func transformFromJSON(value: AnyObject?) -> Array<T>? {
        var result = Array<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(entry)!
                result.append(model)
            }
        }
        return result
    }
    

    func transformToJSON(value: Object?) -> JSON? {
        var results = [AnyObject]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}
