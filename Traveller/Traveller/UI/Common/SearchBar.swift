//
//  SearchBar.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isFocused: Bool
    @Binding var screenContext: ScreenContext
    @State private var isEditing = false
    @State private var placeholderText: String = String(localized: "Search places")
    
    var body: some View {
        HStack {
            TextField(placeholderText, text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        // Clear button
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .onChange(of: searchText) { oldValue, newValue in
                    withAnimation {
                        isFocused = !newValue.isEmpty ? true : false
                    }
                }
                .onChange(of: screenContext) { _, newValue in
                    withAnimation {
                        switch newValue {
                        case .home:
                            placeholderText = String(localized: "Search places")
                        case .trip:
                            placeholderText = String(localized: "Search places")
                        }
                    }
                }
        }
    }
}
