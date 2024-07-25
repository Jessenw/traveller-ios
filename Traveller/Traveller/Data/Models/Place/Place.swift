//
//  Place.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import GoogleMaps
import SwiftData
import SwiftUI

@Model class Place: Hashable {
    let id: String
    let name: String
    let subtitle: String?
    @Attribute(.externalStorage) let images: [Data]
    var isChecked: Bool
    
    init(
        id: String,
        name: String,
        subtitle: String?,
        images: [Data] = [],
        isChecked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.images = images
        self.isChecked = isChecked
    }
}
