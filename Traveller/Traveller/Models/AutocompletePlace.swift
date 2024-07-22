//
//  AutocompletePlace.swift
//  Traveller
//
//  Created by Jesse Williams on 04/07/2024.
//

import Foundation

struct AutocompletePlace: Identifiable {
    let id = UUID()
    let placeId: String // Google Maps place ID
    let name: AttributedString
    let subtitle: AttributedString?
    let distance: Measurement<UnitLength>?
}
