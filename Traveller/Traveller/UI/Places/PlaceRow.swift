//
//  PlaceRow.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceRow: View {
    @Environment(\.modelContext) private var modelContext
    
    var place: Place

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(place.subtitle.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .lineLimit(2)
        }
    }
}
