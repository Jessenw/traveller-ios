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
                SearchBar(searchText: $searchQuery)
                    .padding([.top, .horizontal])
                
                // Trips list
                List {
                    Section {
                        ForEach(trips) { trip in
                            TripRow(trip: trip)
                        }
                        .onDelete(perform: deleteTrip)
                    } header: {
                        HStack {
                            Text("Trips")
                            
                            Spacer()
                            
                            // Add trip button
                            Button(action: {
                                showingCreateDialog = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
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
