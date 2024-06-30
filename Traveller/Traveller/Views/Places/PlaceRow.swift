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
        let isChecked = place.isChecked
        
        HStack {
            // Checked button
            Button(action: {
                withAnimation { place.isChecked.toggle() }
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(place.title)
                    .font(.headline)
                Text(place.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

