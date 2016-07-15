//
//  MainViewController.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation



class MainViewController: UIViewController, SearchViewControllerDelegate {
    
    // MARK: - Variables
    let kTAG_TXT_FROM = 101
    let kTAG_TXT_TO = 102
    
    var mLocationManager : CLLocationManager?
    var mCurrentUserLocation : CLLocation?
    var bDidGetUserLocationFirstTime : Bool = false
    var mMarkerFrom : GMSMarker?
    var mMarkerTo : GMSMarker?
    var mMarkerUserLocation : GMSMarker?
    var mLocationFrom : MyLocation?
    var mLocationTo : MyLocation?
    @IBOutlet var mViewVehicleBottomConstraint: NSLayoutConstraint!
    
    // MARK: - IBOutlets
    @IBOutlet var mMapView: GMSMapView!
    @IBOutlet var mViewFrom: UIView!
    @IBOutlet var mViewTo: UIView!
    @IBOutlet var mTxtFrom: UITextField!
    @IBOutlet var mTxtTo: UITextField!
    @IBOutlet var mViewCurrentLocation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Other methods
    
    func setupUI() -> Void {
        mViewTo.layer.cornerRadius = 8.0;
        mViewTo.clipsToBounds = true;
        
        mViewFrom.layer.cornerRadius = 8.0;
        mViewFrom.clipsToBounds = true;
        
        mViewCurrentLocation.layer.cornerRadius = 16.0;
        mViewCurrentLocation.clipsToBounds = true;
        
        mTxtTo.tag = kTAG_TXT_TO
        mTxtFrom.tag = kTAG_TXT_FROM
        
        // setup map view
        self.setupMapView()
        
        // set constraint for vehicle view
        mViewVehicleBottomConstraint.constant = -50
    }
    
    func setupLocationManager() -> Void {
        if mLocationManager == nil {
            mLocationManager = CLLocationManager()
            mLocationManager?.delegate = self
            mLocationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            
            mLocationManager?.requestWhenInUseAuthorization()
        }
        
        mLocationManager?.startUpdatingLocation()
    }
    
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
        
    }
    
    func showMessageForLocationServicesPermission() -> Void {
    
    
//        self.showAlert("location service is disabled", message:"Please turn on Location Service in your device settings.", delegate: self, tag: 101, cancelButton: "no, thanks", ok: "settings", okHandler: { () -> Void? in
//            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
//            print()
//            }, cancelhandler: )
    }
    
    // MARK: - Actions
    

    @IBAction func btnCurrentLocation_Touched(sender: AnyObject) {
        
        if (mCurrentUserLocation != nil) {
            let camera = GMSCameraPosition.cameraWithLatitude((mCurrentUserLocation?.coordinate.latitude)!, longitude: (mCurrentUserLocation?.coordinate.longitude)!, zoom: mMapView.camera.zoom)
            mMapView.animateToCameraPosition(camera)
        }
    }
    
    // MARK: - SearchViewController Delegate
    
    func searchViewController(viewController: SearchViewController, choseLocation location: MyLocation, forFromAddress boolValue: Bool) {
        if boolValue == true {
            // from address
            mLocationFrom = location
            
            // relocate marker
            mMarkerFrom?.position = location.mLocationCoordinate!
            
        } else {
            // to address
            mLocationTo = location
            
            // relocate marker
            mMarkerTo?.position = location.mLocationCoordinate!
        }
        
        // move camera
        mMapView.camera = GMSCameraPosition.cameraWithTarget(location.mLocationCoordinate!, zoom: mMapView.camera.zoom)
    }
}

// MARK: - UITextField Delegate

extension MainViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Init search view controller
        var bFrom : Bool = false
        var location : MyLocation?
        if textField.tag == kTAG_TXT_FROM {
            bFrom = true
            location = mLocationFrom!
        } else {
            bFrom = false
            location = mLocationTo!
        }
        let vc = SearchViewController(nibName: "SearchViewController", bundle: nil, delegate: self, locationInfo: location!, searchForFromAddress: bFrom)
        self.presentViewController(vc, animated: true) { 
            
        }
        return false
    }
}



// MARK: - Location Manager Delegate

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        mCurrentUserLocation = location
        
        if mCurrentUserLocation != nil && bDidGetUserLocationFirstTime == false {
            bDidGetUserLocationFirstTime = true
            // current location marker
            mMarkerUserLocation = GMSMarker()
            mMarkerUserLocation?.map = mMapView
            mMarkerUserLocation?.icon = UIImage(named: "img_default_marker")
            mMarkerUserLocation?.title = ""
            mMarkerUserLocation?.zIndex = 1
            
            // animate map move to user location
            mMapView.camera = GMSCameraPosition.cameraWithTarget((mCurrentUserLocation?.coordinate)!, zoom: 16)
            
            // setup marker from
            mMarkerFrom = GMSMarker()
            mMarkerFrom?.map = mMapView
            mMarkerFrom?.icon = UIImage(named: "default_marker")
            mMarkerFrom?.position = (location?.coordinate)!
            mMarkerFrom?.zIndex = 2
            
            // init from location & to location
            mLocationFrom = MyLocation(location: (location?.coordinate)!, name: "")
            
            mLocationTo = MyLocation(location: (location?.coordinate)!, name: "")
            
        }
        
        // update marker user location position
        mMarkerUserLocation?.position = (location?.coordinate)!
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        TUtilsSwift.log(error.localizedDescription, logLevel: TUtilsSwift.TLogLevel.DEBUG)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {

        case .AuthorizedWhenInUse:
            mLocationManager?.startUpdatingLocation()
            break
        case .Denied:
            self.showMessageForLocationServicesPermission()
            break
        case .NotDetermined:
            
            break
        case .Restricted:
            self.showMessageForLocationServicesPermission()
            break
        default:
            break
        }
    }
}

