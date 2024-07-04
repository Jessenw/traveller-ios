//
//  TripDetailViewModel.swift
//  Traveller
//
//  Created by Jesse Williams on 03/07/2024.
//

import Combine
import GoogleMaps
import GooglePlacesSwift

@MainActor
class PlacesService: ObservableObject {
    
    private let placesClient = PlacesClient.shared
    
    /// Given a queryQuery Google Places to retrieve a list of autocomplete place suggestions
    /// - Parameter query: The string given to Google for autocomplete
    /// - Returns: A list of autocomplete places. Provides enough information to render a preview
    func fetchAutocompletePredictions(query: String) async throws -> [AutocompletePlaceSuggestion] {
        let autocompleteRequest = AutocompleteRequest(query: query, filter: nil)
        
        return switch await placesClient.fetchAutocompleteSuggestions(with: autocompleteRequest) {
            case .success(let autocompleteSuggestions):
                try autocompleteSuggestions.map { suggestion in
                    switch suggestion {
                    case .place(let place):
                        return place
                    @unknown default:
                        throw(PlacesError.internal("Unknown AutocompleteSuggestion type"))
                    }
                }
            case .failure(let placesError):
                throw placesError
        }
    }
}
