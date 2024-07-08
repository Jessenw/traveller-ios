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
    
    // Sheet presentation state
    @State private var currentDetent = PresentationDetent.fraction(1/3)
    @State private var dragIndicator = Visibility.visible
    @State private var sheetCornerRadius: CGFloat? = nil
    @State private var sheetDetents = [PresentationDetent.fraction(1/3)]
    @State private var maxDetent = PresentationDetent.height(700)
    
    init() {
        sheetDetents.append(maxDetent)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                MapContainerView()
                    .sheet(isPresented: $isShowingSheet) {
                        VStack {
                            if searchIsFocused {
                                PlaceSearchList(searchQuery: $searchQuery)
                            } else {
                                TripList()
                            }
                            
                            Spacer()
                        }
                        .presentationDetents(
                            [.fraction(1/3), maxDetent],
                            selection: $currentDetent
                        )
                        .presentationBackgroundInteraction(.enabled(upThrough: maxDetent))
                        .interactiveDismissDisabled()
                        .presentationDragIndicator(dragIndicator)
                        .presentationCornerRadius(sheetCornerRadius)
                        .onChange(of: currentDetent) {
                            withAnimation {
                                let isSheetMaxHeight = currentDetent == maxDetent
                                dragIndicator = isSheetMaxHeight ? .hidden : .visible
                                sheetCornerRadius = isSheetMaxHeight ? 0 : nil
                            }
                        }
                    }
                
                SearchBar(
                    searchText: $searchQuery,
                    isFocused: $searchIsFocused
                )
                .padding([.top, .horizontal])
            }
        }
    }
}

#Preview {
    HomeScreen()
}
