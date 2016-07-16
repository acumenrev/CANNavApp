//
//  AppDelegate.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability?
    var bCanReachInternet : Bool = false


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // config CocoaLumberjack
        configCocoaLumberjack()
        
        // config Reachability
        configReachability()
        
        // setup google api
        GMSServices.provideAPIKey(Constants.Google.API_KEY.rawValue)
        
        // init windos
        initWindow()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Reachability
    func setupReachability(hostName hostName: String?) {
        
        TUtilsSwift.log("reachability with host: " + hostName!, logLevel: TUtilsSwift.TLogLevel.DEBUG)
        
        do {
            let reachability = try hostName == nil ? Reachability.reachabilityForInternetConnection() : Reachability(hostname: hostName!)
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            // cannot reach with address
            return
        } catch {}
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
    }
    
    /**
     Start notifier
     */
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            
            return
        }
    }
    
    /**
     Stop notifier
     */
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
        reachability = nil
    }
    
    /**
     Reachability changed
     
     - parameter note: Notification
     */
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            bCanReachInternet = true
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.CanReachInternet.rawValue, object: true)
        } else {
            bCanReachInternet = false
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notification.CanReachInternet.rawValue, object: false)
        }
    }
    
    // MARK: - Other
    
    /**
     Init window
     */
    func initWindow() -> Void {
        let vcSpash : MainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = vcSpash
        self.window?.makeKeyAndVisible()
    }
    
    /**
     Config Cocoa Lumberjack
     */
    func configCocoaLumberjack() -> Void {
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        DDLog.addLogger(DDASLLogger.sharedInstance())
        
        let fileLogger : DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60*60*24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        DDLog.addLogger(fileLogger)
    }
    
    /**
     Config reachability
     */
    func configReachability() -> Void {
        setupReachability(hostName: "www.google.com")
        startNotifier()
    }
}

