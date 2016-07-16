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
    
    static let kAPI_QUERY_FROM_ADDRESS = "https://maps.googleapis.com/maps/api/geocode/json?address=%@"
    static let kAPI_QUERY_FROM_GEO = "https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@"
    static let kAPI_GET_DIRECTIONS = "https://maps.googleapis.com/maps/api/directions/json?&origin=%@&destination=%@&mode=%@"
    
}

class NetworkManager: NSObject {
    
    var mQueryLocationMapper : Mapper<QueryLocationResultListModel>?
    var mDirectionMapper : Mapper<DirectionModel>?
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
        mQueryLocationMapper = Mapper<QueryLocationResultListModel>()
        mDirectionMapper = Mapper<DirectionModel>()
    }
    
    /**
     Make a request URL
     
     - parameter appendString: String need to be appended to original URL
     
     - returns: URL which will be used to make a request
     */
    func makeRequestURL(appendString : String) -> String {
        return appendString.urlEncode()
    }
    
    /**
     Query address based on geo value
     
     - parameter latvalue:   Lat value
     - parameter lngValue:   Lng value
     - parameter completion: Completion block
     - parameter fail:       Fail block
     
     - returns: Alamofire.Request instance
     */
    func queryAddressBasedOnLatLng(latvalue : Double,
                                   lngValue : Double,
                                   completion:(locationResult : QueryLocationResultModel?) -> (),
                                   fail:(failError : NSError) -> ()) -> Alamofire.Request? {
        var url = String(format: NetworkDef.kAPI_QUERY_FROM_GEO, String(latvalue), String(lngValue))
        url = makeRequestURL(url)
        
        TUtilsSwift.log(url, logLevel: TUtilsSwift.TLogLevel.DEBUG)
        return Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData) :
                let jsonData = responseData as! NSDictionary
                NSLog("query address success: %@", jsonData)
                
                // mapping
                let result = self.mQueryLocationMapper?.map(jsonData)
                
                if result?.status?.lowercaseString == "ok" {
                    if result?.results?.count > 0 {
                        let firstResult = (result?.results?.first)! as QueryLocationResultModel
                        completion(locationResult: firstResult)
                    } else {
                        // no data
                        completion(locationResult: nil)
                    }
                } else {
                    // no data
                    completion(locationResult: nil)
                }
                
                break
            case .Failure(let error):
                NSLog("query address failed with error: %@", error.localizedDescription)
                fail(failError: error)
                break
            }
            
            
        }
        
    }
    
    /**
     Query lat lng based on address
     
     - parameter address:    Address
     - parameter completion: Completion block
    - parameter fail:       Fail block
     
     - returns: Alamofire.Request instance
     */
    func queryLatLongBasedOnAddress(address : String,
                                    completion:(locationResults : Array<QueryLocationResultModel>) -> (),
                                    fail:(failError : NSError) -> ()) -> Alamofire.Request? {
        var url = String(format: NetworkDef.kAPI_QUERY_FROM_ADDRESS, address)
        url = makeRequestURL(url)
        
        return Alamofire.request(.GET, url).responseJSON { res in
            switch res.result {
            case .Success(let responseData):
                
                let jsonData = responseData as! NSDictionary
                NSLog("query lat long based on address success: %@", jsonData)
                
                // parse json
                let result = self.mQueryLocationMapper?.map(jsonData)
                
                if result?.status?.lowercaseString == "ok" {
                    completion(locationResults: (result?.results)!)
                } else {
                    // no data
                    completion(locationResults: Array<QueryLocationResultModel>())
                }
                
                break
            case .Failure(let error):
                NSLog("query lat long based on address failed: %@", error.localizedDescription)
                fail(failError: error)
                break
            }
        }
    }

    func getDirectionPath(origin : CLLocationCoordinate2D,
                          destination : CLLocationCoordinate2D,
                          movingMode : String,
                          completion:(direction : DirectionModel) -> (),
                          fail:(failError : NSError) -> ()) -> Alamofire.Request? {
        let originString = String(format: "%@,%@", String(origin.latitude), String(origin.longitude))
        let destinationString = String(format: "%@,%@", String(destination.latitude), String(destination.longitude))

        var url = String(format: NetworkDef.kAPI_GET_DIRECTIONS, originString, destinationString, movingMode)
        url = makeRequestURL(url)
        
        NSLog("get direction path: %@", url)
        return Alamofire.request(.GET, url).responseJSON(completionHandler: { res in
            switch res.result {
            case .Success(let responseData):
                // success
                let jsonData = responseData as! NSDictionary
                NSLog("get direction path success: %@", jsonData)
                
                let direction = self.mDirectionMapper?.map(jsonData)
                completion(direction: direction!)
                
                break
            case .Failure(let error):
                // error
                fail(failError: error)
                break
            }
        })
    }
    
}
