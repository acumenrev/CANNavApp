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
    var mLastTimeSendRequest : NSTimeInterval = 0
    
    @IBOutlet var mViewMap: UIView!
    @IBOutlet var mMapView: GMSMapView!
    @IBOutlet var mViewPick: UIView!
    @IBOutlet var mTblViewMain: UITableView!
    @IBOutlet var mViewSearchAddress: UIView!
    @IBOutlet var mTxtSearch: UITextField!
    @IBOutlet var mViewSearchModeText: UIView!
    @IBOutlet var mViewSearchModeMap: UIView!
    
    var mMarker : GMSMarker? = nil
    var mListAddress : Array<QueryLocationResultModel> = Array<QueryLocationResultModel>()
    var bSearchAddressMode : Bool = true
    var mDelegate : SearchViewControllerDelegate? = nil
    var mMyLocation : MyLocation?
    var mSearchForFromAddress : Bool = false
    var bSearchModeMapActive : Bool = true
    let mSelectedColor : UIColor = UIColor(red: 255/255, green: 214/255, blue: 92/255, alpha: 1)
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, delegate: SearchViewControllerDelegate?, locationInfo : MyLocation?, searchForFromAddress : Bool) {
        
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
        registerNibs()
        
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
        
        mViewPick.layer.cornerRadius = 12.0
        mViewPick.clipsToBounds = true
        bSearchAddressMode = false
        
        refreshSearchModeBar()
        
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
    
    /**
     Setup marker
     */
    func setupMarker() -> Void {
        
        if mMarker == nil {
            mMarker = GMSMarker()
            mMarker?.map = mMapView
            mMarker?.icon = UIImage(named: "default_marker")
            mMarker?.title = ""
            mMarker?.zIndex = 1
            if mMyLocation != nil {
                mMarker?.position = (mMyLocation?.mLocationCoordinate)!
                // animate map move to user location
                mMapView.camera = GMSCameraPosition.cameraWithTarget((mMyLocation?.mLocationCoordinate)!, zoom: 16)
            } else {
                recenterMarkerInMapView()
            }
        }
    }
    
    /**
     Register nibs for table view
     */
    func registerNibs() -> Void {
        mTblViewMain.registerCellNib(SearchTableViewCell.self)
    }
    
    /**
     Refresh search mode bar
     */
    func refreshSearchModeBar() -> Void {
        mViewSearchModeMap.backgroundColor = UIColor.clearColor()
        mViewSearchModeText.backgroundColor = UIColor.clearColor()
        if bSearchModeMapActive == false {
            mViewSearchModeText.backgroundColor = mSelectedColor
        } else {
            mViewSearchModeMap.backgroundColor = mSelectedColor
        }
    }
    
    // MARK: - Actions
    
    @IBAction func btnSet_Touched(sender: AnyObject) {
        
        let newLocation = MyLocation(location: mMarker!.position, name: mTxtSearch.text!)
        if self.mDelegate != nil {
            self.mDelegate?.searchViewController(self, choseLocation: newLocation, forFromAddress: mSearchForFromAddress)
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
        bSearchModeMapActive = true
        mViewSearchAddress.hidden = true
        mViewMap.hidden = false
        self.view.sendSubviewToBack(mViewSearchAddress)
        self.view.bringSubviewToFront(mViewMap)
        self.view.endEditing(true)
        refreshSearchModeBar()
    }
    
    @IBAction func btnSearchAddress_Touched(sender: AnyObject) {
        bSearchModeMapActive = false
        mViewSearchAddress.hidden = false
        mViewMap.hidden = true
        self.view.sendSubviewToBack(mViewMap)
        self.view.bringSubviewToFront(mViewSearchAddress)
        refreshSearchModeBar()
        
        // active keyboard
        mTxtSearch.becomeFirstResponder()
    }
}

// MARK: - TextField Delegate

extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        mViewSearchAddress.hidden = false
        mViewMap.hidden = true
        bSearchModeMapActive = false
        refreshSearchModeBar()
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let range = range.stringRangeForText(textField.text!)
        let output = textField.text!.stringByReplacingCharactersInRange(range, withString: string)
        
        if output.length > 3 {
            // send request
            let currentTimeInMs = NSDate().timeIntervalSince1970
            if (currentTimeInMs - mLastTimeSendRequest) > 2 {
                // time gap between 2 requests must be greater than 2 seconds
                if TUtilsSwift.appDelegate().bCanReachInternet == true {

                    NetworkManager.sharedInstance.queryLatLongBasedOnAddress(output, completion: { (locationResults) in
                        if self.mListAddress.count > 0 {
                            self.mListAddress.removeAll()
                        }
                        
                        self.mListAddress += locationResults
                        
                        // reload table data
                        self.mTblViewMain.reloadData()
                        }, fail: { (failError) in
                            
                    })
                } else {
                    self.navigationController?.presentViewController(self.showNoInternetConnectionMessage(), animated: true, completion: nil)
                }
                
                
            }
        } else {
            mListAddress.removeAll()
            mTblViewMain.reloadData()
        }
        
        return true
    }
    
    
    
    
}

// MARK: - GMSMapView Delegate

extension SearchViewController : GMSMapViewDelegate {
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        mViewPick.hidden = true
        
        self.recenterMarkerInMapView()
        
        // resign text field
        self.view.endEditing(true)
    }
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        mViewPick.hidden = false
        
        if mSearchRequest != nil {
            // cancel previous request
            mSearchRequest?.cancel()
        }
        // request location
        if TUtilsSwift.appDelegate().bCanReachInternet == true {
            // request
            NetworkManager.sharedInstance.queryAddressBasedOnLatLng(position.target.latitude, lngValue: position.target.longitude, completion: { (locationResult) in
                self.mTxtSearch.text = locationResult?.formattedAddress
                }, fail: { (failError) in
                    
            })
        }
    }
    
    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
        self.recenterMarkerInMapView()
    }

    func recenterMarkerInMapView() -> Void {
        // get the center of mapview
        let center = mMapView.convertPoint(mMapView.center, fromView: mViewMap)
        
        // reset ther marker position so it moves without animation
        mMapView.clear()
        mMarker?.appearAnimation = kGMSMarkerAnimationNone
        mMarker?.position = mMapView.projection.coordinateForPoint(center)
        mMarker?.map = mMapView
    }
    
}

// MARK: - UIScrollView Delegate

extension SearchViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - UITableView Delegate

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mListAddress.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        cell.selectionStyle = .Gray
        
        let location = self.mListAddress[indexPath.row]
        cell.setAddress(location.formattedAddress!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.view.endEditing(true)
        let location = self.mListAddress[indexPath.row]
        
        if self.mDelegate != nil {
            self.mDelegate?.searchViewController(self, choseLocation: MyLocation(location: CLLocationCoordinate2DMake(location.lat!, location.lng!), name: location.formattedAddress!), forFromAddress: self.mSearchForFromAddress)
        }
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}
