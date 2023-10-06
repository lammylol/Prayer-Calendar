//
//  Item.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/6/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
