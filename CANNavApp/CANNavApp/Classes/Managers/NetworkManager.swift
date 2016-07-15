//
//  NetworkManager.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import Alamofire
import CocoaLumberjack
import ObjectMapper

class NetworkDef: NSObject {
    
    /*static NSString *kURL_GOOGLE_GEOCODE = @"https://maps.googleapis.com/maps/api/geocode/";
     static NSString *kAPI_FROM_ADDRESS = @"json?address=%@";
     static NSString *kAPI_FROM_LAT_LONG = @"json?&latlng=%ld,%ld";
     */
    
    static let kAPI_QUERY_FROM_ADDRESS = "https://maps.googleapis.com/maps/api/geocode/json?address=%@"
    static let kAPI_QUERY_FROM_GEO = "https://maps.googleapis.com/maps/api/geocode/json?latlng=%ld,%ld"
    static let kAPI_DISTANCE_MATRIX = "https://maps.googleapis.com/maps/api/distancematrix/"
    
}

class NetworkManager: NSObject {
    
    class var sharedInstance : NetworkManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        
        return Static.instance!
    }
    
    override init() {
        
    }
    
    /**
     Make a request URL
     
     - parameter appendString: String need to be appended to original URL
     
     - returns: URL which will be used to make a request
     */
    static func makeRequestURL(appendString : String) -> String {
        return appendString.urlEncode()
    }
    
    static func queryAddressBasedOnLatLng(latvalue : Double,
                                   lngValue : Double,
                                   completion:() -> Void?,
                                   fail:(failError : NSError) -> Void?) -> Alamofire.Request? {
        var url = String(format: NetworkDef.kAPI_QUERY_FROM_GEO, latvalue, lngValue)
        url = makeRequestURL(url)
        
        
        return Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData) :
                break
            case .Failure(let error):
                break
            }
            
            
        }
        
    }
    
    static func queryLatLongBasedOnAddress(address : String,
                                    completion:() -> Void?,
                                    fail:(failError : NSError) -> Void?) -> Alamofire.Request? {
        var url = String(format: NetworkDef.kAPI_QUERY_FROM_ADDRESS, address)
        url = makeRequestURL(url)
        
        return Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                break
            case .Failure(let error):
                break
            }
        }
    }

}
