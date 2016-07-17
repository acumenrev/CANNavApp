//
//  NetworkManagerTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble
import Alamofire
import CoreLocation

class NetworkManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetworkManagerSingleton() {
        expect(NetworkManager.sharedInstance).notTo(equal(nil))
    }
    
    func testInit() {
        expect(NetworkManager.sharedInstance.mDirectionMapper).notTo(equal(nil))
        expect(NetworkManager.sharedInstance.mQueryLocationMapper).notTo(equal(nil))
        
        expect(NetworkDef.kAPI_GET_DIRECTIONS).notTo(beEmpty())
        expect(NetworkDef.kAPI_QUERY_FROM_GEO).notTo(beEmpty())
        expect(NetworkDef.kAPI_QUERY_FROM_ADDRESS).notTo(beEmpty())
    }
    
    func testQueryLatLong() {
        let myExpect = expectationWithDescription("queryLatLong")
        
        let request = NetworkManager.sharedInstance.queryLatLongBasedOnAddress("02 Ngo Duc Ke", completion: { (locationResults) in
            myExpect.fulfill()
            }) { (failError) in
                
        }
        
        expect(request).notTo(equal(nil))
        
        self.waitForExpectationsWithTimeout(15.0) { (error) in
            NSLog("query lat long failed with error: " + (error?.localizedDescription)!)
        }
    }
    
    func testQueryAddress() {
        let myExpect = expectationWithDescription("queryAddress")
        
        let request = NetworkManager.sharedInstance.queryAddressBasedOnLatLng(0, lngValue: 0, completion: { (locationResult) in
            myExpect.fulfill()
            }) { (failError) in
                
        }
        
        expect(request).notTo(equal(nil))
        
        self.waitForExpectationsWithTimeout(15) { (error) in
            NSLog("query address failed with error: " + (error?.localizedDescription)!)
        }
    }
    
    func testGetDirectionPathsWithWalkingMode() {
        let myExpect = expectationWithDescription("getDirectionPathsWithWalkingMode")
        // 10.7639873663694,106.652912031008
        
        // 10.7744861,106.706047
        let originPoint = CLLocationCoordinate2DMake(10.7639873663694, 106.652912031008)
        let destinationPoint = CLLocationCoordinate2DMake(10.7744861, 106.706047)
        
        let request = NetworkManager.sharedInstance.getDirectionPath(originPoint, destination : destinationPoint, movingMode : "walking", completion : { (direction) in
                myExpect.fulfill()
            }, fail: { (failError) in
        
        })
        
        expect(request).notTo(equal(nil))
        
        self.waitForExpectationsWithTimeout(15) { (error) in
            NSLog("get direction paths with walking mode error: " + (error?.localizedDescription)!)
        }
        
        
    }
    
    func testGetDirectionPathsWithDrivingMode() {
        let myExpect = expectationWithDescription("getDirectionPathsWIthDrivingMode")
        
        let originPoint = CLLocationCoordinate2DMake(10.7639873663694, 106.652912031008)
        let destinationPoint = CLLocationCoordinate2DMake(10.7744861, 106.706047)
        
        let request = NetworkManager.sharedInstance.getDirectionPath(originPoint, destination : destinationPoint, movingMode : "driving", completion : { (direction) in
            myExpect.fulfill()
            }, fail: { (failError) in
                
        })
        
        expect(request).notTo(equal(nil))
        
        self.waitForExpectationsWithTimeout(15) { (error) in
            NSLog("get direction paths with driving mode error: " + (error?.localizedDescription)!)
        }
        
    }
}
