//
//  PlaceDetailViewModel.swift
//  Traveller
//
//  Created by Jesse Williams on 21/07/2024.
//

import SwiftUI
import Combine

@MainActor
class PlaceDetailViewModel: ObservableObject {
    @Published var place: PlaceDetail?
    @Published var isSaved: Bool = false
    @Published var isLoading: Bool = true
    @Published var fetchError: Error?

    private let placesService = PlacesService.shared

    var placeId: String
    var trip: Trip?
    
    init(placeId: String, trip: Trip?) {
        self.placeId = placeId
        self.trip = trip
        fetchPlaceDetails()
    }
    
    func fetchPlaceDetails() {
        Task {
            do {
                let placeDetails = try await placesService.fetchPlaceDetails(placeId: placeId)
                DispatchQueue.main.async {
                    self.place = placeDetails
                    self.isSaved = self.trip?.places.contains(where: { $0.googleId == self.placeId }) ?? false
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.fetchError = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func saveTrip() {
        guard let place, let trip else { return }
        trip.places.append(place.toPlace())
        isSaved = true
    }
    
    func removeTrip() {
        guard let trip else { return }
        trip.places.removeAll { $0.googleId == placeId }
        isSaved = false
    }
}
