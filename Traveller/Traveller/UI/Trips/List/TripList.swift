//
//  TripList.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftData
import SwiftUI

struct TripList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var sheetState: ResizableSheetState
    
    @Query private var trips: [Trip]
    @State private var showingCreateDialog = false
    @State private var searchQuery = ""
    @State private var presentedTrip: Trip?
    
    @State private var headerSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            if let presentedTrip {
                TripDetail(trip: presentedTrip) {
                    self.presentedTrip = nil
                    configureSheet()
                }
                .animation(.easeInOut(duration: 0.5), value: presentedTrip)
            } else {
                List {
                    ForEach(trips) { trip in
                        TripRow(trip: trip)
                            .onTapGesture {
                                presentedTrip = trip
                            }
                    }
                    .onDelete(perform: deleteTrip)
                }
                .animation(.easeInOut(duration: 0.5), value: presentedTrip)
            }
        }
        .onAppear {
            configureSheet()
        }
        .sheet(isPresented: $showingCreateDialog) {
            CreateTripDialog()
        }
    }
    
    private func configureSheet() {
        sheetState.isFullscreen = false
        sheetState.headerTitle = "Trips"
        sheetState.headerButtonTapped = {
            showingCreateDialog.toggle()
        }
        sheetState.size = CGSize(
            width: 300, height: 400)
    }
    
    private func deleteTrip(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }
}
