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
import PKHUD


class MainViewController: UIViewController, SearchViewControllerDelegate {
    
    enum MovingMode : String {
        case Driving = "driving"
        case Walking = "walking"
    }
    
    // MARK: - Variables
    let kTAG_TXT_FROM = 101
    let kTAG_TXT_TO = 102
    let kTAG_BTN_MOVING_MODE_CAR = 101
    let kTAG_BTN_MOVING_MODE_BICYCLE = 102
    let kTAG_BTN_MOVING_MODE_WALKING = 104
    
    var mLocationManager : CLLocationManager?
    var mCurrentUserLocation : CLLocation?
    var bDidGetUserLocationFirstTime : Bool = false
    var mMarkerFrom : GMSMarker?
    var mMarkerTo : GMSMarker?
    var mMarkerUserLocation : GMSMarker?
    var mLocationFrom : MyLocation?
    var mLocationTo : MyLocation?
    var mSearchViewControllerFrom : SearchViewController?
    var mSearchViewControllerTo : SearchViewController?
    var mCurrentMovingMode : MovingMode = .Driving
    var mCurrentDirection : DirectionModel?
    var mDirectionDictionary : NSMutableDictionary = NSMutableDictionary()
    var mCurrentPolyline : GMSPolyline?
    let mSelectedColor : UIColor = UIColor(red: 255/255, green: 214/255, blue: 92/255, alpha: 1)
    @IBOutlet var mViewVehicleBottomConstraint: NSLayoutConstraint!
    
    // MARK: - IBOutlets
    @IBOutlet var mMapView: GMSMapView!
    @IBOutlet var mViewFrom: UIView!
    @IBOutlet var mViewTo: UIView!
    @IBOutlet var mTxtFrom: UITextField!
    @IBOutlet var mTxtTo: UITextField!
    @IBOutlet var mViewCurrentLocation: UIView!
    @IBOutlet var mViewMovingModeCar: UIView!
    @IBOutlet var mViewMovingModeWalking: UIView!
    @IBOutlet var mLblDistance: UILabel!
    @IBOutlet var mLblDuration: UILabel!
    @IBOutlet var mViewDistanceAndDuration: UIView!
    
    
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
    /**
     Setup UI on view
     */
    func setupUI() -> Void {
        mViewTo.layer.cornerRadius = 8.0;
        mViewTo.clipsToBounds = true;
        
        mViewFrom.layer.cornerRadius = 8.0;
        mViewFrom.clipsToBounds = true;
        
        mViewCurrentLocation.layer.cornerRadius = 16.0;
        mViewCurrentLocation.clipsToBounds = true;
        
        mTxtTo.tag = kTAG_TXT_TO
        mTxtFrom.tag = kTAG_TXT_FROM
        
        mViewDistanceAndDuration.hidden = true
        
        // setup map view
        self.setupMapView()
        
        // set constraint for vehicle view
        mViewVehicleBottomConstraint.constant = -50
    }
    
    /**
     Setup location manager
     */
    func setupLocationManager() -> Void {
        if mLocationManager == nil {
            mLocationManager = CLLocationManager()
            mLocationManager?.delegate = self
            mLocationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            
            mLocationManager?.requestWhenInUseAuthorization()
        }
        
        mLocationManager?.startUpdatingLocation()
    }
    
    /**
     Setup Google Map View
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
        
    }
    
    /**
     Show message for location service permission
     */
    func showMessageForLocationServicesPermission() -> Void {
        let alert = self.showAlert(Constants.AlertTitle.NoLocationService.rawValue, message: Constants.AlertMessage.NoLocationService.rawValue, delegate: nil, tag: 101, cancelButton: "no, thanks", ok: "settings", okHandler: { 
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }, cancelhandler: {})
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Draw paths on Google Maps
     */
    func drawPaths() -> Void {
        
        if mMarkerTo != nil && mMarkerFrom != nil {
            var direction : DirectionModel?
            if mDirectionDictionary.objectForKey(mCurrentMovingMode.rawValue) != nil {
                direction = mDirectionDictionary.objectForKey(mCurrentMovingMode.rawValue) as? DirectionModel
            }
            
            
            if direction != nil {
                // draw paths
                drawPaths(direction!)
            } else {
                // request directions from google
                // get directions
                NetworkManager.sharedInstance.getDirectionPath(mMarkerFrom!.position, destination: mMarkerTo!.position, movingMode: mCurrentMovingMode.rawValue, completion: { (direction) in
                    // cache in NSDictionary
                    self.mDirectionDictionary.setObject(direction, forKey: self.mCurrentMovingMode.rawValue)
                    
                    // draw paths
                    self.drawPaths(direction)
                    }, fail: { (failError) in
                        
                })
            }
        }
    }
    
    /**
     Draw paths on Map
     
     - parameter direction: DirectionModel
     */
    func drawPaths(direction : DirectionModel) -> Void {
        if direction.routes?.count > 0 {
            let route = direction.routes?.first
            
            let path = GMSPath(fromEncodedPath: (route?.paths)!)
            if mCurrentPolyline == nil {
                mCurrentPolyline = GMSPolyline()
                mCurrentPolyline!.strokeColor = UIColor.blueColor()
                mCurrentPolyline!.strokeWidth = 2.0
            }
            
            mCurrentPolyline?.path = path
            mCurrentPolyline?.map = mMapView
            
            // enable moving mode bar
            self.mViewVehicleBottomConstraint.constant = 0
            
            // update duration and distance
            self.refreshDistanceAndDurationValues(direction)
        }
    }
    
    /**
     Refresh moving mode bar
     */
    func refreshMovingModeBar() -> Void {
        mViewMovingModeCar.backgroundColor = UIColor.clearColor()
        mViewMovingModeWalking.backgroundColor = UIColor.clearColor()
        
        switch mCurrentMovingMode {
        case .Driving:
            mViewMovingModeCar.backgroundColor = mSelectedColor
            break
        case .Walking:
            mViewMovingModeWalking.backgroundColor = mSelectedColor
            break
        default:
            break
        }
        
    }
    
    /**
     Refresh distance and duration values
     
     - parameter direction: DirectionModel
     */
    func refreshDistanceAndDurationValues(direction : DirectionModel) -> Void {
        if direction.routes?.count > 0 {
            
            if direction.routes?.first?.legs?.count > 0 {
                mViewDistanceAndDuration.hidden = false
                mLblDuration.text = direction.routes?.first?.legs?.first?.duration
                mLblDistance.text = direction.routes?.first?.legs?.first?.distance
            }
        }
    }
    
    // MARK: - Actions
    

    @IBAction func btnCurrentLocation_Touched(sender: AnyObject) {
        
        if (mCurrentUserLocation != nil) {
            let camera = GMSCameraPosition.cameraWithLatitude((mCurrentUserLocation?.coordinate.latitude)!, longitude: (mCurrentUserLocation?.coordinate.longitude)!, zoom: mMapView.camera.zoom)
            mMapView.animateToCameraPosition(camera)
        }
    }
    
    @IBAction func btnTo_Touched(sender: AnyObject) {
        if mSearchViewControllerTo == nil {
            mSearchViewControllerTo = SearchViewController(nibName: "SearchViewController", bundle: nil, delegate: self, locationInfo: mLocationTo, searchForFromAddress: false)
        }
        mSearchViewControllerTo?.mMyLocation = mLocationTo
        
        self.presentViewController(mSearchViewControllerTo!, animated: true, completion: nil)
    }
    
    @IBAction func btnFrom_Touched(sender: AnyObject) {
        if mSearchViewControllerFrom == nil {
            mSearchViewControllerFrom = SearchViewController(nibName: "SearchViewController", bundle: nil, delegate: self, locationInfo: mLocationFrom, searchForFromAddress: true)
        }
        mSearchViewControllerFrom?.mMyLocation = mLocationFrom
        self.presentViewController(mSearchViewControllerFrom!, animated: true, completion: nil)
    }
    
    @IBAction func changeMovingMode(sender: AnyObject) {
        let btn = sender as! UIButton
        
        var movingMode = MovingMode.Driving
        switch btn.tag {
        case kTAG_BTN_MOVING_MODE_CAR:
            movingMode = MovingMode.Driving
            break
        case kTAG_BTN_MOVING_MODE_WALKING:
            movingMode = MovingMode.Walking
            break
        default:
            break
        }
        if mCurrentMovingMode == movingMode {
            return
        }
        
        mCurrentMovingMode = movingMode
        self.refreshMovingModeBar()
        self.drawPaths()
    }
    
    
    // MARK: - SearchViewController Delegate
    
    func searchViewController(viewController: SearchViewController, choseLocation location: MyLocation, forFromAddress boolValue: Bool) {
        
        // remove direction cache
        mDirectionDictionary.removeAllObjects()
        
        if boolValue == true {
            // from address
            mLocationFrom = location
            
            // relocate marker
            if mMarkerFrom == nil {
                // init marker to
                mMarkerFrom = GMSMarker()
                
                mMarkerFrom?.icon = UIImage(named: "default_marker")
                mMarkerFrom?.zIndex = 2
            } else {
                mMarkerFrom?.map = nil
            }
            
            mMarkerFrom?.position = location.mLocationCoordinate!
            mTxtFrom.text = location.mLocationName
            
            mMarkerFrom?.map = mMapView
            mMarkerFrom?.title = location.mLocationName
        } else {
            // to address
            mLocationTo = location
            
            // relocate marker
            if mMarkerTo == nil {
                // init marker to
                mMarkerTo = GMSMarker()
                
                mMarkerTo?.icon = UIImage(named: "default_marker")
                mMarkerTo?.zIndex = 2
            } else {
                mMarkerTo?.map = nil
            }
            mMarkerTo?.position = location.mLocationCoordinate!
            mMarkerTo?.title = location.mLocationName
            mMarkerTo?.map = mMapView
            mTxtTo.text = location.mLocationName
        }
        
        self.drawPaths()
        // move camera
        mMapView.camera = GMSCameraPosition.cameraWithTarget(location.mLocationCoordinate!, zoom: (mMapView.camera.zoom==4 ? 16 : mMapView.camera.zoom))
    }
}

// MARK: - Location Manager Delegate

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        mCurrentUserLocation = location
        
        if mCurrentUserLocation != nil && bDidGetUserLocationFirstTime == false {
            mViewCurrentLocation.hidden = false
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
            
            // request location
            if TUtilsSwift.appDelegate().bCanReachInternet {
                NetworkManager.sharedInstance.queryAddressBasedOnLatLng((location?.coordinate.latitude)!, lngValue: (location?.coordinate.longitude)!, completion: { (locationResult) in
                    self.mTxtFrom.text = locationResult?.formattedAddress
                    }, fail: { (failError) in
                        
                })
            }
            
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
            mViewCurrentLocation.hidden = true
            self.showMessageForLocationServicesPermission()
            break
        case .NotDetermined:
            self.setupLocationManager()
            break
        case .Restricted:
            mViewCurrentLocation.hidden = true
            self.showMessageForLocationServicesPermission()
            break
        default:
            break
        }
    }
}

