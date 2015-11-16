//
//  DwindleExtensions.swift
//  DwindleDating
//
//  Created by Muhammad Rashid on 15/11/2015.
//  Copyright © 2015 infinione. All rights reserved.
//

import Foundation

extension Array {
    
    func shuffled() -> [Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex { // Check if you are not trying to swap an element with itself
                swap(&elements[index], &elements[newIndex])
            }
        }
        return elements
    }
}