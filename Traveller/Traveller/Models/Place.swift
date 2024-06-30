//
//  Place.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import SwiftData
import SwiftUI

@Model class Place {
    let title: String
    let subtitle: String
    var isChecked: Bool
    
    init(title: String, subtitle: String, isChecked: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isChecked = isChecked
    }
}
