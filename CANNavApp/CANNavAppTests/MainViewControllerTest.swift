//
//  MainViewControllerTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/17/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble
import GoogleMaps
import CoreLocation

class MainViewControllerTest: XCTestCase {
    
    var mVC : MainViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mVC = MainViewController(nibName: "MainViewController", bundle: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mVC = nil
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
    
    func testInit() {
        
        expect(self.mVC).notTo(equal(nil))
        self.mVC?.loadView()
        
        // mLocationManager
        if CLLocationManager.locationServicesEnabled() == true {
            expect(self.mVC?.mLocationManager).notTo(equal(nil))
            expect(self.mVC?.mLocationManager?.desiredAccuracy == kCLLocationAccuracyKilometer).to(equal(true))
            expect(self.mVC?.mLocationManager?.delegate != nil).to(equal(true))
        }
        
        // mCurrentUserLocation
        expect(self.mVC?.mCurrentUserLocation).notTo(equal(nil))
        
        // bDidGetUserLocationFirstTime
        expect(self.mVC?.bDidGetUserLocationFirstTime).to(equal(false))
        
        // mMarkerFrom
        expect(self.mVC?.mMarkerFrom).to(equal(nil))
        
        // mMarkerTo
        expect(self.mVC?.mMarkerTo).to(equal(nil))
        
        // mMarkerUserLocation
        expect(self.mVC?.mMarkerUserLocation).to(equal(nil))
        
        // mLocationFrom
        expect(self.mVC?.mLocationFrom).to(equal(nil))
        
        // mLocationTo
        expect(self.mVC?.mLocationTo).to(equal(nil))
        
        // mSearchViewControllerFrom
        expect(self.mVC?.mSearchViewControllerFrom).to(equal(nil))
        
        // mSearchViewControllerTo
        expect(self.mVC?.mSearchViewControllerTo).to(equal(nil))
        
        // mCurrentMovingMode
        expect(self.mVC?.mCurrentMovingMode.rawValue).to(equal("driving"))
        
        // mCurrentDirection
        expect(self.mVC?.mCurrentDirection == nil).to(equal(true))
        
        // mDirectionDictionary
        expect(self.mVC?.mDirectionDictionary).to(equal(nil))
        
        // mCurrentPolyline
        expect(self.mVC?.mCurrentPolyline == nil).to(equal(true))
    
        // mSelectedColor
        expect(self.mVC?.mSelectedColor).notTo(equal(nil))
        
        // mMapView
        expect(self.mVC?.mMapView).notTo(equal(nil))
        
        // mViewFrom
        expect(self.mVC?.mViewFrom).notTo(equal(nil))
        
        // mViewTo
        expect(self.mVC?.mViewTo).notTo(equal(nil))
        
        // mTxtFrom
        expect(self.mVC?.mTxtFrom).notTo(equal(nil))
        
        // mTxtTo
        expect(self.mVC?.mTxtTo).notTo(equal(nil))
        
        // mViewCurrentLocation
        expect(self.mVC?.mViewCurrentLocation).notTo(equal(nil))
        
        // mViewMovingModeCar
        expect(self.mVC?.mViewMovingModeCar).notTo(equal(nil))
        
        // mViewMovingModeWalking
        expect(self.mVC?.mViewMovingModeWalking).notTo(equal(nil))
        
        // mLblDistance
        expect(self.mVC?.mLblDistance).notTo(equal(nil))
        
        // mLblDuration
        expect(self.mVC?.mLblDuration).notTo(equal(nil))
        
        // mViewDistanceAndDuration
        expect(self.mVC?.mViewDistanceAndDuration).notTo(equal(nil))
        
        // mViewVehicleBottomConstraint
        expect(self.mVC?.mViewVehicleBottomConstraint).notTo(equal(nil))
    }
    
    func testConformingToSearchViewControllerDeleagate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(SearchViewControllerDelegate)).to(equal(true))
    }
    
    func testConformingToLocationManagerDelegate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(CLLocationManagerDelegate)).to(equal(true))
    }
    
    
}
