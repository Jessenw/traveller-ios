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
    
    var body: some View {
        HStack {
            TextField("Search places...", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .onTapGesture {
                    isFocused = true
                }
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        // Clear button
                        if isFocused {
                            Button(action: {
                                searchText = ""
                                isFocused = false
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
    }
}
