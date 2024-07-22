import GooglePlacesSwift
import SwiftUI

struct PlaceDetailView: View {
    @StateObject private var viewModel: PlaceDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(placeId: String, trip: Trip?) {
        _viewModel = StateObject(wrappedValue: PlaceDetailViewModel(placeId: placeId, trip: trip))
    }
    
    var detailView: some View {
        let weekdayText = viewModel.place?.openingHours?.weekdayText ?? []
        return List {
            Section("Opening hours") {
                ForEach(weekdayText, id: \.hashValue) { day in
                    Text(day)
                }
            }
        }
        .scrollDisabled(true)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView
                    .padding()
                summaryView
                    .padding([.horizontal, .bottom])
                
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
                        .ignoresSafeArea(edges: .trailing)
                        .padding(.horizontal)
                    }
                    .listRowBackground(Color.clear)
                }
                
                detailView
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .animation(.smooth, value: viewModel.isLoading)
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                    viewModel.isSaved ? viewModel.removeTrip() : viewModel.saveTrip()
                }) {
                    Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                        .disabled(viewModel.isLoading)
                }
            )
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.place?.name ?? "placeholder")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.place?.firstTypeFormatted ?? "Placeholder")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func priceView(priceLevel: Int) -> some View {
        let offset = 2
        let priceLevelsCount = PriceLevel.allCases.count - offset
        return HStack(spacing: 2) {
            ForEach(0...(priceLevelsCount - 2), id: \.self) { i in
                Image(systemName: "dollarsign")
                    .fontWeight(.bold)
                    .foregroundStyle(i <= (priceLevel - offset) ? .green : .secondary)
            }
        }
    }
    
    private var summaryView: some View {
        HStack(alignment: .center) {
            // Hours
            let isOpen = viewModel.place?.isOpen ?? false
            Text(isOpen ? "Open" : "Closed")
                .fontWeight(.bold)
                .foregroundStyle(isOpen ? .green : .red)
                .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            // Rating
            VStack {
                Text("Rating")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .unredacted()
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18))
                        .unredacted()
                    Text(String(format: "%.1f", viewModel.place?.rating ?? 0.0))
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            // Average Cost
            VStack {
                Text("Price")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .unredacted()
                if let priceLevel = viewModel.place?.priceLevel {
                    switch priceLevel {
                    case .unspecified:
                        Text("-")
                            .foregroundStyle(.secondary)
                    case .free:
                        Text("Free")
                    case .expensive, .moderate, .inexpensive, .veryExpensive:
                        if let level = priceLevel.level {
                            priceView(priceLevel: level)
                        } else {
                            Text("-")
                                .foregroundStyle(.red)
                        }
                    @unknown default:
                        Text("-")
                            .foregroundStyle(.red)
                    }
                } else {
                    Text("-")
                        .foregroundStyle(.red)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}


