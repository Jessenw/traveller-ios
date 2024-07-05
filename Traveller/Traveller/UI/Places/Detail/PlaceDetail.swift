//
//  PlaceDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import SwiftUI

struct PlaceDetail: View {
    @ObservedObject private var placesService = PlacesService.shared
    @State private var place: PlaceSearchDetail?
    
    var placeId: String
    
    init(placeId: String) {
        self.placeId = placeId
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let displayName = place?.displayName {
                Text("\(displayName)")
            }
        }
        .task {
            do {
                place = try await placesService
                    .fetchPlaceDetails(placeId: placeId)
            } catch {
                print(error)
            }
        }
    }
}
