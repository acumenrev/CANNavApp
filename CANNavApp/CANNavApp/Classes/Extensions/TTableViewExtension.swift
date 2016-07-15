//
//  TTableViewExtension.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit

public extension UITableView {
    
    /**
     Register cell class
     
     - parameter cellClass: Cell class
     */
    func registerCellClass(cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.registerClass(cellClass, forCellReuseIdentifier: identifier)
    }
    
    /**
     Register cell nib
     
     - parameter cellClass: Cell class
     */
    func registerCellNib(cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    /**
     Register header/footer class
     
     - parameter viewClass: view class
     */
    func registerHeaderFooterViewClass(viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.registerClass(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /**
     Register header/footer class
     
     - parameter viewClass: View class
     */
    func registerHeaderFooterViewNib(viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.registerNib(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}