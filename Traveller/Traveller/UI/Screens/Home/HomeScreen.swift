//
//  HomeScreen.swift
//  Traveller
//
//  Created by Jesse Williams on 04/07/2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var isShowingSheet = true
    @State private var searchIsFocused = false
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            MapContainerView()
                .sheet(isPresented: $isShowingSheet) {
                    VStack {
                        SearchBar(
                            searchText: $searchQuery,
                            isFocused: $searchIsFocused
                        )
                        .padding([.top, .horizontal])
                        
                        if searchIsFocused {
                            PlaceSearchList(searchQuery: $searchQuery)
                        } else {
                            TripList()
                        }
                        
                        Spacer()
                    }
                    .presentationDetents([.fraction(1/3), .large])
                    .interactiveDismissDisabled()
                }
        }
    }
}

#Preview {
    HomeScreen()
}
