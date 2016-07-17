//
//  SearchViewControllerTest.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/17/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import XCTest
import Nimble
import GoogleMaps

class SearchViewControllerTest: XCTestCase {
    
    var mVC : SearchViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let originPoint = CLLocationCoordinate2DMake(10.7639873663694, 106.652912031008)
        self.mVC = SearchViewController(nibName: "SearchViewController", bundle: nil, delegate: nil, locationInfo: MyLocation(location: originPoint, name: "testing"), searchForFromAddress: true)
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
        
        expect(self.mVC?.mLastTimeSendRequest).to(equal(0))
        
        // mMapView
        expect(self.mVC?.mMapView).notTo(equal(nil))
        expect(self.mVC?.mMapView.delegate != nil).to(equal(true))
        
        // mViewPick
        expect(self.mVC?.mViewPick).notTo(equal(nil))
        expect(self.mVC?.mViewPick.hidden).to(equal(false))
        expect(self.mVC?.mViewPick.layer.cornerRadius).to(equal(8))
        expect(self.mVC?.mViewPick.clipsToBounds).to(equal(true))
        
        // mTblViewMain
        expect(self.mVC?.mTblViewMain).notTo(equal(nil))
        expect(self.mVC?.mTblViewMain.delegate != nil).to(equal(true))
        expect(self.mVC?.mTblViewMain.dataSource != nil).to(equal(true))
        
        // mViewSearchAddress
        expect(self.mVC?.mViewSearchAddress).notTo(equal(nil))
        expect(self.mVC?.mViewSearchAddress.hidden).to(equal(true))
        
        // mViewMap
        expect(self.mVC?.mViewMap).notTo(equal(nil))
        expect(self.mVC?.mViewMap.hidden).to(equal(false))
        
        // mTxtSearch
        expect(self.mVC?.mTxtSearch).notTo(equal(nil))
        expect((self.mVC?.mTxtSearch.delegate != nil)).to(equal(true))
        expect(self.mVC?.mTxtSearch.text).notTo(beEmpty())
        
        // mViewSearchModeText
        expect(self.mVC?.mViewSearchModeText).notTo(equal(nil))
        expect(self.mVC?.mViewSearchModeText).to(equal(UIColor.clearColor()))
        
        // mViewSearchModeMap
        expect(self.mVC?.mViewSearchModeMap).notTo(equal(nil))
        expect(self.mVC?.mViewSearchModeMap.backgroundColor).to(equal(self.mVC?.mSelectedColor))
        
        // mMarker
        expect(self.mVC?.mMarker).notTo(equal(nil))
        expect(self.mVC?.mMarker.map).to(equal(self.mVC?.mMapView))
        expect(self.mVC?.mMarker.title).to(beEmpty())
        expect(self.mVC?.mMarker.zIndex).to(equal(1))
        
        // mMyLocation
        expect(self.mVC?.mMyLocation).notTo(equal(nil))
        
        // mSearchForFromAddress
        expect(self.mVC?.mSearchForFromAddress).to(equal(true))
        
        // bSearchModeMapActive
        expect(self.mVC?.bSearchModeMapActive).to(equal(true))
        
        // selected color
        expect(self.mVC?.mSelectedColor).notTo(equal(nil))
        
    }
    
    func testConformToUITableViewDelegate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(UITableViewDelegate)).to(equal(true))
    }
    
    func testConformToUITableViewDataSource() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(UITableViewDataSource)).to(equal(true))
    }
    
    func testConformToGMSMapViewDelegate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(GMSMapViewDelegate)).to(equal(true))
    }
    
    func testConformToScrollViewDelegate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(UIScrollViewDelegate)).to(equal(true))
    }
    
    func testConformToUITextFieldDelegate() {
        expect(self.mVC).notTo(equal(nil))
        expect(self.mVC?.conformsToProtocol(UITextFieldDelegate)).to(equal(true))
    }
}
