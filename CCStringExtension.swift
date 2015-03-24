//
//  StringExtension.swift
//  AlgorithmMatch
//
//  Created by Tullie on 22/03/2015.
//  Copyright (c) 2015 Tullie. All rights reserved.
//

import UIKit

extension String {
    var capitilizedFirstLetter: String {
        if countElements(self) <= 0 {
            return ""
        }
        var first = self.startIndex
        var firstRange = Range(start: first, end: advance(first,1))
        var restRange = Range(start: advance(first,1), end: self.endIndex)
        return self.substringWithRange(firstRange).uppercaseString + self.substringWithRange(restRange)
    }
}
