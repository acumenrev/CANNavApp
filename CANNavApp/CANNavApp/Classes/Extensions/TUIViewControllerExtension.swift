//
//  TUIViewControllerExtension.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

extension UIViewController {
    private struct TVCExtensionProperties {
        static var mLblTitle:UILabel? = nil
        static var mViewTitle:UIView? = nil
    }
    
    var mLblTitle : UILabel? {
        get {
            return objc_getAssociatedObject(self, &TVCExtensionProperties.mLblTitle) as? UILabel
        }
        set {
            if let unwrappedValue = newValue  {
                objc_setAssociatedObject(self, &TVCExtensionProperties.mLblTitle, unwrappedValue as UILabel?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    var mViewTitle : UIView? {
        get {
            return objc_getAssociatedObject(self, &TVCExtensionProperties.mViewTitle) as? UIView
        }
        set {
            if let unwrappedValue = newValue  {
                objc_setAssociatedObject(self, &TVCExtensionProperties.mViewTitle, unwrappedValue as UIView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func setViewTitle(title : String) -> Void {
        
        if mLblTitle == nil {
            mViewTitle = UIView();
            mViewTitle?.frame = CGRectMake(10, 0, UIScreen.mainScreen().bounds.size.width, 40)
            mViewTitle?.backgroundColor = UIColor.clearColor()
            
            
            mLblTitle = UILabel(forAutoLayout: ())
            mViewTitle?.addSubview(mLblTitle!)
            
            mLblTitle?.autoSetDimension(.Height, toSize: 40)
            mLblTitle?.autoAlignAxisToSuperviewAxis(.Horizontal)
            mLblTitle?.autoAlignAxisToSuperviewAxis(.Vertical)
            
        }
        
        mLblTitle?.font = UIFont.systemFontOfSize(18)
        mLblTitle?.backgroundColor = UIColor.clearColor()
        mLblTitle?.adjustsFontSizeToFitWidth = true
        mLblTitle?.textAlignment = .Center
        mLblTitle?.textColor = UIColor.blackColor()
        
        let fontDescriptor  = mLblTitle?.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        
        
        mLblTitle?.font = UIFont(descriptor: fontDescriptor!, size: 0)
        self.navigationItem.titleView = mViewTitle

    }
    
    func showAlert(title : String, message : String, delegate : AnyObject?, tag : Int, cancelButton: String, ok : String, okHandler:() -> Void?, cancelhandler:() -> Void?) -> Void {
        let alertContronoller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        if cancelButton.length > 0 {
            let alertAction = UIAlertAction(title: cancelButton, style: .Cancel, handler: { (action) in
                cancelhandler()
            })
            
            alertContronoller.addAction(alertAction)
        }
        
        if ok.length > 0 {
            let alertAction = UIAlertAction(title: ok, style: .Default, handler: { (action) in
                okHandler()
            })
            
            alertContronoller.addAction(alertAction)
        }
    }
}