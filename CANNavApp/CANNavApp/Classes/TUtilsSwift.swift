//
//  TUtilsSwift.swift
//  dotabuff
//
//  Created by Tri Vo on 6/25/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit
import CocoaLumberjack

class TUtilsSwift: NSObject {
    
    enum TLogLevel {
        case DEBUG
        case INFO
        case WARN
        case VERBOSE
    }
    
    /**
     Checks string is NULL
     
     - parameter value: String value need to be checked
     
     - returns: return true
     */
    static func checkNullString(value : String?) -> String {
        if value == nil {
            return ""
        }
        
        if TUtilsSwift.checkStringNullOrEmpty(value) == true {
            return ""
        }
        
        return value!
    }
    
    /**
     Check string NULL or EMPTY
     
     - parameter value: String balue need to be checked
     
     - returns: true if value is null or empty
     */
    static func checkStringNullOrEmpty(value : String?) -> Bool {
        if value == nil {
            return true
        }
        
        if value!.isEmpty {
            return true
        }
        
        
        let newValue = value!.stringByReplacingOccurrencesOfString(" ", withString: "")
        if newValue.isEmpty {
            return true
        }
        
        return false
    }
    
    /**
     Save image data to local disk
     
     - parameter imgData:  Image Data
     - parameter filePath: file path
     
     - returns: true if everything goes ok
     */
    static func saveImageToLocalDisk(imgData : UIImage, filePath : String) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePathWithFileName = paths.stringByAppendingString(filePath)
        
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(filePathWithFileName) == false {
            // create file
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                UIImagePNGRepresentation(imgData)?.writeToFile(filePathWithFileName, atomically: true)
            })
        }
        return true
    }
    
    /**
     Log
     
     - parameter stringValue: String value need to be logged
     - parameter logLevel:    Log Level
     */
    static func log(stringValue : String, logLevel : TLogLevel) -> Void {
        switch logLevel {
        case .DEBUG:
            DDLogDebug(stringValue)
            break
        case .VERBOSE:
            DDLogVerbose(stringValue)
            break
        case .INFO:
            DDLogInfo(stringValue)
            break
        case .WARN:
            DDLogWarn(stringValue)
            break
        default:
            DDLogDebug(stringValue)
            break
        }
    }
    
    /**
     Get AppDelegate instance
     
     - returns: AppDelegate instance
     */
    static func appDelegate() -> AppDelegate {
            return (UIApplication.sharedApplication().delegate as! AppDelegate)
    }
}
