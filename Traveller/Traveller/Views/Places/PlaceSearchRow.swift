//
//  PlaceSearchRow.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftUI

struct PlaceSearchRow: View {
    let trip: Trip
    let place: Place
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.title)
                    .font(.headline)
                Text(place.subtitle)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {
                addPlace(place: place)
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    private func addPlace(place: Place) {
        trip.places.append(place)
    }
}

#Preview {
    PlaceSearchRow(
        trip: Trip(name: "Name"),
        place: Place(title: "Title", subtitle: "Subtitle"))
}
