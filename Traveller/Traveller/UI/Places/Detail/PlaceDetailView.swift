//
//  PlaceDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceDetailView: View {
    @ObservedObject private var placesService = PlacesService.shared
    @State private var isSaved: Bool = false
    
    @State private var place: PlaceDetail?
    var placeId: String
    
    var trip: Trip?
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Title
            if let name = place?.name {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            } else {
                Text("Coffee Outdoors")
                    .font(.largeTitle)
            }
            // Subtitle
            if let type = place?.types.first {
                Text(type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("Outdoors store")
                    .font(.subheadline)
            }
        }
    }
    
    private var summaryView: some View {
        HStack(alignment: .center) {
            // Hours
            if let isOpen = place?.openingHours?.isOpen {
                Text(isOpen ? "Open" : "Closed")
                    .foregroundStyle(isOpen ? .green : .red)
                    .frame(maxWidth: .infinity)
            } else {
                Text("open")
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
                .frame(height: 20)

            // Rating
            if let rating = place?.rating {
                VStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18))
                        Text(String(format: "%.1f", rating))
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Text("Rating")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("star-4.5")
            }
            
            Divider()
                .frame(height: 20)
            
            // Average Cost
            VStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 18))
                if let priceLevel = place?.priceLevel {
                    Text(priceLevel.priceLevelDescription)
                        .foregroundColor(.secondary)
                } else {
                    Text("moderate")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                summaryView
                
                // Image Carousel
                if let images = place?.images, !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(images, id: \.self) { imageData in
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 150)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .redacted(reason: place == nil ? .placeholder : [])
            .padding()
            .navigationBarItems(
                leading: Button(action: {
                    // Action for closing the screen
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                    saveTrip()
                }) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                }
            )
            .task {
                do {
                    self.place = try await placesService
                        .fetchPlaceDetails(placeId: placeId)
                    isSaved = trip?.places.contains(where: { place in
                        place.googleId == self.placeId
                    }) ?? false
                } catch {
                    print(error)
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
