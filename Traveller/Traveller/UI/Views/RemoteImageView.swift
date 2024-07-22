//
//  RemoteImageView.swift
//  Traveller
//
//  Created by Jesse Williams on 22/07/2024.
//

import GooglePlacesSwift
import SwiftUI

struct RemoteImageView: View {
    @ObservedObject private var placesService = PlacesService.shared
    @State var uiImage: UIImage?
    @State var isLoading: Bool = true
    
    var photo: Photo
    
    var body: some View {
        Image(uiImage: uiImage ?? UIImage(systemName: "exclamationmark.circle.fill")!)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 150)
            .cornerRadius(10)
            .redacted(reason: isLoading ? .placeholder : [])
            .task {
                do {
                    let photoData = try await placesService.fetchPlacePhoto(photo: photo)
                    uiImage = UIImage(data: photoData)
                    isLoading = false
                } catch {}
            }
    }
}
