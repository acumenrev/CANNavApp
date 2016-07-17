//
//  DirectionModelTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/17/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble
import Alamofire
import CoreLocation

class DirectionModelTest: XCTestCase {
    
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
    
    
    func testParsingJSONFromRequest() {
        let originPoint = CLLocationCoordinate2DMake(10.7639873663694, 106.652912031008)
        let destinationPoint = CLLocationCoordinate2DMake(10.7744861, 106.706047)
        
        let request = NetworkManager.sharedInstance.getDirectionPath(originPoint, destination : destinationPoint, movingMode : "driving", completion : { (direction) in
            expect(direction.routes?.count).to(beGreaterThan(0))
            expect(direction.routes?.first?.paths).notTo(beEmpty())
            expect(direction.routes?.first?.paths.count).to(beGreaterThan(0))
            expect(direction.routes?.first?.legs?.first?.duration).notTo(beEmpty())
            expect(direction.routes?.first?.legs?.first?.distance).notTo(beEmpty())
            }, fail: { (failError) in
                
        })
        
    }
}
