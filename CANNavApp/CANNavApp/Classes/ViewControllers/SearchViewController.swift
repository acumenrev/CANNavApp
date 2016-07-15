//
//  SearchViewController.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import Alamofire

protocol SearchViewControllerDelegate {
    
    func searchViewController(viewController: SearchViewController, choseLocation location : MyLocation, forFromAddress boolValue : Bool) -> Void
    
}

class SearchViewController: UIViewController {
    
    var mSearchRequest : Alamofire.Request? = nil
    
    @IBOutlet var mViewMap: UIView!
    @IBOutlet var mMapView: GMSMapView!
    @IBOutlet var mViewPick: UIView!
    @IBOutlet var mTblViewMain: UITableView!
    @IBOutlet var mViewSearchAddress: UIView!
    @IBOutlet var mTxtSearch: UITextField!
    
    var mMarker : GMSMarker? = nil
    var mListAddress : NSMutableArray = NSMutableArray()
    var bSearchAddressMode : Bool = true
    var mDelegate : SearchViewControllerDelegate? = nil
    var mMyLocation : MyLocation?
    var mSearchForFromAddress : Bool = false
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, delegate: SearchViewControllerDelegate?, locationInfo : MyLocation, searchForFromAddress : Bool) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.mDelegate = delegate
        self.mMyLocation = locationInfo
        self.mSearchForFromAddress = searchForFromAddress
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        registerNibs()
        
        // setup UI
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Other methods
    
    /**
     Setup UI
     */
    func setupUI() -> Void {
        
        setupMapView()
        
        // setup marker
        setupMarker()
        
        self.view.sendSubviewToBack(mViewSearchAddress)
        self.view.bringSubviewToFront(mViewMap)
    }
    
    /**
     Setup MapView
     */
    func setupMapView() -> Void {
        // config Google Maps
        mMapView.userInteractionEnabled = true
        mMapView.mapType = kGMSTypeNormal
        mMapView.settings.myLocationButton = false
        mMapView.myLocationEnabled = false
        mMapView.settings.compassButton = true
        mMapView.settings.zoomGestures = true
        mMapView.settings.scrollGestures = true
        mMapView.settings.indoorPicker = false
        mMapView.settings.tiltGestures = false
        mMapView.settings.rotateGestures = true
        mMapView.delegate = self
    }
    
    func setupMarker() -> Void {
        if mMarker == nil {
            mMarker = GMSMarker()
            mMarker?.map = mMapView
            mMarker?.icon = UIImage(named: "default_marker")
            mMarker?.title = ""
            mMarker?.zIndex = 1
            mMarker?.position = (mMyLocation?.mLocationCoordinate)!
            
            // animate map move to user location
            mMapView.camera = GMSCameraPosition.cameraWithTarget((mMyLocation?.mLocationCoordinate)!, zoom: 16)
        }
    }
    
    /**
     Register nibs for table view
     */
    func registerNibs() -> Void {
        mTblViewMain.registerCellNib(SearchTableViewCell.self)
    }
    
    // MARK: - Actions
    
    @IBAction func btnSet_Touched(sender: AnyObject) {
        if self.mDelegate != nil {
            self.mDelegate?.searchViewController(self, choseLocation: mMyLocation!, forFromAddress: mSearchForFromAddress)
        }
        
        self.dismissViewControllerAnimated(true) { 
            
        }
        
    }
    
    
    
    @IBAction func btnBack_Touched(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    @IBAction func btnSearchMap_Touched(sender: AnyObject) {
        mViewSearchAddress.hidden = true
        mViewMap.hidden = false
        self.view.sendSubviewToBack(mViewSearchAddress)
        self.view.bringSubviewToFront(mViewMap)
        self.view.endEditing(true)
    }
    
    @IBAction func btnSearchAddress_Touched(sender: AnyObject) {
        mViewSearchAddress.hidden = false
        mViewMap.hidden = true
        self.view.sendSubviewToBack(mViewMap)
        self.view.bringSubviewToFront(mViewSearchAddress)
    }
}

// MARK: - TextField Delegate

extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        mViewSearchAddress.hidden = false
        mViewMap.hidden = true
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let range = range.stringRangeForText(textField.text!)
        let output = textField.text!.stringByReplacingCharactersInRange(range, withString: string)
        
        
        
        return true
    }
    
    
}

// MARK: - GMSMapView Delegate

extension SearchViewController : GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        mViewPick.hidden = true
        
        // resign text field
        self.view.endEditing(true)
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        mViewPick.hidden = false
    }
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        if mMarker != nil {
            mMarker?.position = position.target
            mMyLocation?.mLocationCoordinate = position.target
        }
    }
    
}

// MARK: - UITableView Delegate

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
