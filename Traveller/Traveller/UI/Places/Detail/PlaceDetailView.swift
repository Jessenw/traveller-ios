import SwiftUI

struct PlaceDetailView: View {
    @StateObject private var viewModel: PlaceDetailViewModel
    
    init(placeId: String, trip: Trip?) {
        _viewModel = StateObject(wrappedValue: PlaceDetailViewModel(placeId: placeId, trip: trip))
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.place?.name ?? "placeholder")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.place?.types.first?.rawValue ?? "Placeholder")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var summaryView: some View {
        HStack(alignment: .center) {
            // Hours
            let isOpen = viewModel.place?.isOpen ?? false
            Text(isOpen ? "Open" : "Closed")
                .foregroundStyle(isOpen ? .green : .red)
                .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 20)
            
            // Rating
            VStack {
                Text("Rating")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18))
                    Text(String(format: "%.1f", viewModel.place?.rating ?? 0.0))
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 20)
            
            // Average Cost
            VStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 18))
                Text(viewModel.place?.priceLevel.priceLevelDescription ?? "moderate")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                    .padding()
                summaryView
                    .padding()
                
                // Image Carousel
                if let images = viewModel.place?.images, !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(images, id: \.self) { imageData in
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 150)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .animation(.smooth, value: viewModel.isLoading)
            .navigationBarItems(
                leading: Button(action: {
                    // Action for closing the screen
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                    viewModel.isSaved ? viewModel.removeTrip() : viewModel.saveTrip()
                }) {
                    Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                }
            )
        }
    }
}
