//
//  TripList.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftData
import SwiftUI

fileprivate struct HeaderSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct TripList: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var state: ResizableSheetState
    
    @Query private var trips: [Trip]
    @State private var showingCreateDialog = false
    @State private var searchQuery = ""
    
    @State private var headerSize: CGSize = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Text("Trips")
                            .font(.title)
                        
                        Spacer()
                        
                        Button(
                            action: {
                                withAnimation {
                                    state.size.height = 300
                                }
//                                showingCreateDialog.toggle()
                            },
                            label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.primary)
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                    .modifier(MeasureSizeModifier<HeaderSizePreferenceKey> { _ in })
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(trips) { trip in
                                TripRow(trip: trip)
                            }
                            .onDelete(perform: deleteTrip)
                        }
                    }
                }
                .padding()
            }
        }
        .onPreferenceChange(HeaderSizePreferenceKey.self) { size in
            state.size = CGSize(
                width: 300, height: 550)
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
