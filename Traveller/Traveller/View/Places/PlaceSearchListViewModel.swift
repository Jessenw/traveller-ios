////
////  PlaceSearchListViewModel.swift
////  Traveller
////
////  Created by Jesse Williams on 01/07/2024.
////
//
//import Foundation
//import GooglePlaces
//
//@MainActor
//class PlacesViewModel: ObservableObject {
//    @Published var places: [Place] = []
//
//    private let placesClient = GMSPlacesClient.shared()
//    
//    func fetchPlaces(searchQuery: String) async throws -> [GMSPlace] {
//        return try await withCheckedThrowingContinuation { continuation in
//            let filter = GMSAutocompleteFilter()
//            
//            placesClient.findAutocompletePredictions(
//                fromQuery: searchQuery,
//                filter: filter,
//                sessionToken: nil) { (results, error) in
//                    if let error = error {
//                        continuation.resume(throwing: error)
//                        return
//                    }
//                    
//                    guard let results = results else {
//                        continuation.resume(returning: [])
//                        return
//                    }
//                    
//                    let placeIDs = results.map { $0.placeID }
//                    do {
//                        try await fetchPlaceDetails(placeIDs: placeIDs)
//                    } catch {
//                        
//                    }
//                }
//        }
//    }
//    
//    func fetchPlaceDetails(placeIDs: [String]) async throws {
//        var places: [GMSPlace] = []
//    }
//}
