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
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                if let subtitle = place.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .lineLimit(2)
        }
    }
}
