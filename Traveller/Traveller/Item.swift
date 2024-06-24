//
//  Item.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
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
