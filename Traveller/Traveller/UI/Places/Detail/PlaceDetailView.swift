import GooglePlacesSwift
import SwiftUI

struct PlaceDetailView: View {
    @StateObject private var viewModel: PlaceDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var statusMessage: String = ""
    @State private var showStatusBar: Bool = false
    
    init(placeId: String, trip: Trip?) {
        _viewModel = StateObject(wrappedValue: PlaceDetailViewModel(placeId: placeId, trip: trip))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                headerView.padding()
                summaryView.padding([.horizontal, .bottom])
                imageCarousel
                openingHoursView
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .animation(.smooth, value: viewModel.isLoading)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    closeButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
                    
            }
        }
    }
    
    // MARK: - Header view
    
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
    
    // MARK: - Summary view
    
    private var summaryView: some View {
        HStack(alignment: .center) {
            statusView
            Divider().frame(height: 40)
            ratingView
            Divider().frame(height: 40)
            priceView
        }
        .frame(maxWidth: .infinity)
    }
    
    private var statusView: some View {
        let isOpen = viewModel.place?.isOpen ?? false
        return Text(isOpen ? "Open" : "Closed")
            .fontWeight(.bold)
            .foregroundStyle(isOpen ? .green : .red)
            .frame(maxWidth: .infinity)
    }
    
    private var ratingView: some View {
        VStack {
            Text("Rating")
                .font(.caption)
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
    }
    
    private var priceView: some View {
        VStack {
            Text("Price")
                .font(.caption)
                .foregroundColor(.secondary)
            if let priceLevel = viewModel.place?.priceLevel, let level = priceLevel.level {
                HStack(spacing: 2) {
                    ForEach(0...2, id: \.self) { i in
                        Image(systemName: "dollarsign")
                            .fontWeight(.bold)
                            .foregroundStyle(i <= (level - 2) ? .green : .secondary)
                    }
                }
            } else {
                Text("-").foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: Image carousel
    
    private var imageCarousel: some View {
        Group {
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
                    .padding(.horizontal)
                }
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Detail views
    
    private var openingHoursView: some View {
        let weekdayText = viewModel.place?.openingHours?.weekdayText ?? []
        return List {
            Section("Opening hours") {
                ForEach(weekdayText, id: \.hashValue) { day in
                    Text(day)
                }
            }
        }
    }
    
    // MARK: - Navigation toolbar buttons
    
    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark")
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.isSaved ? viewModel.removeTrip() : viewModel.saveTrip()
        }) {
            Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                .disabled(viewModel.isLoading)
        }
    }
}
