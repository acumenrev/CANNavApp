//
//  MyLocationTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble
import CoreLocation

class MyLocationTest: XCTestCase {
    
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
    
    func testEmptyInitalization() {
        let myLocation = MyLocation()
        expect(myLocation).notTo(equal(nil))
        
        expect(myLocation.mLocationName).to(equal(""))
        expect(myLocation.mLocationCoordinate?.latitude).to(equal(0))
        expect(myLocation.mLocationCoordinate?.longitude).to(equal(0))
    }
    
    func testCustomIntialization() {
        let myLocation = MyLocation(location: CLLocationCoordinate2DMake(1,1), name: "test")
        
        expect(myLocation.mLocationName).to(equal("test"))
        expect(myLocation.mLocationCoordinate?.latitude).to(equal(1))
        expect(myLocation.mLocationCoordinate?.longitude).to(equal(1))
        
        
    }
    
}
