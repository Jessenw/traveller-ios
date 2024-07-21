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
final class PlacesService: ObservableObject {
    
    static let shared = PlacesService()
    private let placesClient = PlacesClient.shared
    
    private init() {}
    
    /// Given a queryQuery Google Places to retrieve a list of autocomplete place suggestions
    /// - Parameter query: The string given to Google for autocomplete
    /// - Returns: A list of autocomplete places. Provides enough information to render a preview
    func fetchAutocompletePredictions(query: String) async throws -> [AutocompletePlace] {
        let request = AutocompleteRequest(query: query, filter: nil)
        
        return switch await placesClient.fetchAutocompleteSuggestions(with: request) {
        case .success(let suggestions):
            try suggestions.map { suggestion in
                switch suggestion {
                case .place(let place):
                    return AutocompletePlace(
                        placeId: place.placeID,
                        name: place.legacyAttributedFullText.string,
                        subtitle: place.legacyAttributedSecondaryText?.string,
                        distance: place.distance
                    )
                @unknown default:
                    throw(PlacesError.internal("Unknown AutocompleteSuggestion type"))
                }
            }
        case .failure(let placesError):
            throw placesError
        }
    }
    
    func fetchPlaceDetails(placeId: String) async throws -> PlaceDetail {
        let fetchPlaceRequest = FetchPlaceRequest(
            placeID: placeId,
            placeProperties: [
                PlaceProperty.displayName,
                PlaceProperty.formattedAddress,
                PlaceProperty.currentOpeningHours,
                PlaceProperty.priceLevel,
                PlaceProperty.rating,
                PlaceProperty.numberOfUserRatings,
                PlaceProperty.websiteURL,
                PlaceProperty.photos,
                PlaceProperty.businessStatus,
                PlaceProperty.types
            ]
        )
        
        var fetchedPlace: GooglePlacesSwift.Place
        switch await placesClient.fetchPlace(with: fetchPlaceRequest) {
        case .success(let place):
            fetchedPlace = place
        case .failure(let placesError):
            throw(PlacesError.internal("Error fetching place \(placesError)"))
        }
        
        // Use the place details to fetch a photo's image
        var imagesData = [Data]()
        if let photos = fetchedPlace.photos {
            imagesData = try await fetchPlacePhotos(photos: photos)
        }
                
        // Build the place search detail
        return PlaceDetail(
            googleId: placeId,
            name: fetchedPlace.displayName,
            formattedAddress: fetchedPlace.formattedAddress,
            priceLevel: fetchedPlace.priceLevel,
            businessStatus: fetchedPlace.businessStatus,
            openingHours: fetchedPlace.currentOpeningHours,
            rating: fetchedPlace.rating,
            userRatingsCount: fetchedPlace.numberOfUserRatings,
            websiteURL: fetchedPlace.websiteURL,
            images: imagesData, 
            types: fetchedPlace.types)
    }
    
    func fetchPlacePhotos(photos: [Photo]) async throws -> [Data] {
        var photosData = [Data]()
        for photo in photos {
            let fetchPhotoRequest = FetchPhotoRequest(photo: photo, maxSize: CGSizeMake(400, 400))
            
            switch await placesClient.fetchPhoto(with: fetchPhotoRequest) {
            case .success(let uiImage):
                if let data = uiImage.pngData() {
                    photosData.append(data)
                }
            case .failure(let placesError):
                throw(PlacesError.internal("Error fetching photo \(placesError)"))
            }
        }
        
        return photosData
    }
}
