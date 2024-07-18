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
    @State private var showingCreateDialog = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(trips) { trip in
                        TripRow(trip: trip)
                    }
                    .onDelete(perform: deleteTrip)
                }
                .listRowSpacing(8)
                .navigationTitle("Trips")
                
                Spacer()
                
                HStack {
                    Button(action: {
                        showingCreateDialog = true
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
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(isPresented: $showingCreateDialog) {
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
