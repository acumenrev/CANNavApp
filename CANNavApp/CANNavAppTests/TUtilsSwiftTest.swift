//
//  TUtilsSwiftTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/16/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble


class TUtilsSwiftTest: XCTestCase {
    
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
    
    func testAppDelegate() {
        let appDelegate = TUtilsSwift.appDelegate()
        
        expect(appDelegate).to(beAnInstanceOf(AppDelegate.self))
    }
    
    func testCheckNullString() {
        let bValue1 = TUtilsSwift.checkNullString("   ")
        let bValue2 = TUtilsSwift.checkNullString("1")
        let bValue3 = TUtilsSwift.checkNullString("")
        let bValue4 = TUtilsSwift.checkNullString(".&")
        
        expect(bValue1).to(equal(""))
        expect(bValue2).to(equal("1"))
        expect(bValue3).to(equal(""))
        expect(bValue4).to(equal(".&"))
    }
    
    func testCheckStringNullOrEmpty() {
        let bValue1 = TUtilsSwift.checkStringNullOrEmpty("   ")
        let bValue2 = TUtilsSwift.checkStringNullOrEmpty("1")
        let bValue3 = TUtilsSwift.checkStringNullOrEmpty("")
        let bValue4 = TUtilsSwift.checkStringNullOrEmpty(".&")
        
        expect(bValue1).to(equal(true))
        expect(bValue2).to(equal(false))
        expect(bValue3).to(equal(true))
        expect(bValue4).to(equal(false))
    }
    
    
}
