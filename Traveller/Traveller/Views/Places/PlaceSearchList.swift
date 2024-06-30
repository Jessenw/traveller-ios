//
//  PlacesSearchList.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import GooglePlaces
import SwiftData
import SwiftUI

struct PlaceSearchList: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Binding var places: [Place]
    var trip: Trip

    var body: some View {
        List(places) { place in
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
    }
    
    private func addPlace(place: Place) {
        trip.places.append(place)
    }
}
