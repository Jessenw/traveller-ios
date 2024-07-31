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

extension Place {
    static let modelData: [Place] = [
        Place(
            id: "001",
            name: "Wellington Botanic Garden",
            subtitle: "Beautiful gardens with native and exotic plants",
            images: [Data()], // Assume this contains actual image data
            isChecked: true
        ),
        Place(
            id: "002",
            name: "Te Papa Museum",
            subtitle: "National museum and art gallery of New Zealand",
            images: [Data(), Data()], // Assume these contain actual image data
            isChecked: false
        ),
        Place(
            id: "003",
            name: "Mount Victoria Lookout",
            subtitle: "Panoramic views of Wellington and its harbour",
            images: [Data(), Data(), Data()], // Assume these contain actual image data
            isChecked: true
        ),
        Place(
            id: "004",
            name: "Zealandia Ecosanctuary",
            subtitle: nil,
            images: [], // No images for this place
            isChecked: false
        ),
        Place(
            id: "005",
            name: "Wellington Cable Car",
            subtitle: "Historic cable car with city views",
            images: [Data()], // Assume this contains actual image data
            isChecked: true
        ),
        Place(
            id: "006",
            name: "Weta Workshop",
            subtitle: "Film"
        )
    ]
}
