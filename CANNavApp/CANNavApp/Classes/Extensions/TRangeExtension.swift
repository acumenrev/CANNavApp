//
//  TRangeExtension.swift
//  CANNavApp
//
//  Created by Tri Vo on 7/15/16.
//  Copyright © 2016 acumenvn. All rights reserved.
//

import Foundation

extension NSRange {
    func stringRangeForText(string: String) -> Range<String.Index> {
        let start = string.startIndex.advancedBy(self.location)
        let end = start.advancedBy(self.length)
        return Range<String.Index>(start: start, end: end)
    }
}