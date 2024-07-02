//
//  PlacesSearchList.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import GoogleMaps
import GooglePlaces
import SwiftData
import SwiftUI

struct PlaceSearchList: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Binding var places: [Place]
    var trip: Trip

    var body: some View {
        List(places) { place in
            PlaceSearchRow(trip: trip, place: place)
        }
    }
}
