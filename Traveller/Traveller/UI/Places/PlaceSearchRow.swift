//
//  PlaceSearchRow.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftUI

struct PlaceSearchRow: View {
    @State private var isAdded = false
    
    let place: AutocompletePlace
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                Image(systemName: "mappin.circle.fill")
                if let distance = place.distance {
                    let convertedDistance = distance.converted(to: .meters).value
                    Text("\(convertedDistance)")

                }
            }
            .foregroundStyle(.primary)
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                if let subtitle = place.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .lineLimit(2)
        }
    }
}
