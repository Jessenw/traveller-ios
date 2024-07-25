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
    @Query private var trips: [Trip]
    
    @State private var isShowingCreateSheet = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(trips) { trip in
                        NavigationLink(destination: TripDetailView(trip: trip)) {
                            TripRow(trip: trip)
                        }
                    }
                    .onDelete(perform: deleteTrip)
                }
                .listRowSpacing(8)
                .navigationTitle("Trips")
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isShowingCreateSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Trip")
                        }
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding()
            }
        }
        .sheet(isPresented: $isShowingCreateSheet) {
            CreateTripDialog()
        }
    }
    
    private func deleteTrip(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }
}

#Preview {
    TripList()
}
