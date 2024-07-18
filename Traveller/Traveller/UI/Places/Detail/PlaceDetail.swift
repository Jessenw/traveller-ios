//
//  PlaceDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceDetail: View {
    @Environment(\.modelContext) private var modelContext: ModelContext

    @ObservedObject private var placesService = PlacesService.shared
    @State private var place: PlaceSearchDetail?
    @State private var isSaved: Bool = false
    
    var placeId: String
    var trip: Trip?
    
    var body: some View {
        VStack(alignment: .leading) {
            
        }
        .task {
            do {
                place = try await placesService
                    .fetchPlaceDetails(placeId: placeId)
            } catch {
                print(error)
            }
        }
        .navigationTitle(place?.displayName ?? "")
        .toolbar {
            ToolbarItem {
                Button(action: {
                    isSaved.toggle()
                    if isSaved {
                        saveTrip()
                    } else {
                        removeTrip()
                    }
                }) {
                    Image(
                        systemName: isSaved ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
    
    private func saveTrip() {
        if let place {
            trip?.places.append(place.toPlace())
        }
    }
    
    private func removeTrip() {
        trip?.places.removeAll {
            $0.googleId == placeId
        }
    }
}
