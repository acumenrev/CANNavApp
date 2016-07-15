//
//  TImageExtension.swift
//  dotabuff
//
//  Created by Tri Vo on 6/24/16.
//  Copyright © 2016 acumen. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     Trim image
     
     - parameter trimRect: Rect need to be trimmed
     
     - returns: Trimmed image
     */
    func trim(trimRect trimRect :CGRect) -> UIImage {
        if CGRectContainsRect(CGRect(origin: CGPointZero, size: self.size), trimRect) {
            if let imageRef = CGImageCreateWithImageInRect(self.CGImage, trimRect) {
                return UIImage(CGImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.drawInRect(CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
}