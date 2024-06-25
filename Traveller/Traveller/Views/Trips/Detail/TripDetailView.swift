//
//  TripDetailView.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TripDetailView: View {
    var trip: Trip
    @State private var isShowingSheet = true
    
    var body: some View {
        MapContainerView()
            .sheet(isPresented: $isShowingSheet) {
                TripDetailSheet(trip: trip)
                    .presentationDetents([.medium, .large])
                    .interactiveDismissDisabled()
            }
    }
}

struct TripDetailSheet: View {
    @State private var selectedSegment = 0
    @State private var placesTodoItems: [TodoItem] = [
        TodoItem(title: "Visit Eiffel Tower", subheading: "Paris, France", additionalSubheading: "Buy tickets online", isChecked: false, imageName: "eiffel_tower"),
        TodoItem(title: "See the Colosseum", subheading: "Rome, Italy", additionalSubheading: "Check opening hours", isChecked: true, imageName: "colosseum")
    ]
    @State private var tasksTodoItems: [TodoItem] = [
        TodoItem(title: "Buy groceries", subheading: "Milk, Bread, Eggs", additionalSubheading: "Remember to check for discounts", isChecked: false, imageName: "groceries"),
        TodoItem(title: "Walk the dog", subheading: "30 minutes around the park", additionalSubheading: "Bring water and treats", isChecked: true, imageName: "dog"),
        TodoItem(title: "Read a book", subheading: "Finish reading 'SwiftUI for Beginners'", additionalSubheading: "Take notes for each chapter", isChecked: false, imageName: "book")
    ]
    
    var trip: Trip
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        // Trip name
                        Text(trip.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Trip detail
                        if let detail = trip.detail {
                            Text(detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        // Trip dates
                        HStack {
                            if let startDate = trip.startDate, let endDate = trip.endDate {
                                HStack {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("\(Utilities.formattedDate(startDate)) - \(Utilities.formattedDate(endDate))")
                                        .font(.caption)
                                    Text("•")
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            // Member avatars
                            HStack(spacing: 4) {
                                ForEach(trip.members, id: \.self) { member in
                                    Circle()
                                        .fill(Utilities.randomColor())
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    Spacer()
                }
            }
            .padding([.horizontal, .top])
            
            VStack {
                Picker("Select List", selection: $selectedSegment) {
                    Text("Places").tag(0)
                    Text("Tasks").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedSegment == 0 {
                    TodoListView(todoItems: $placesTodoItems, additionalSubheadingStyle: .footnote, additionalSubheadingColor: .blue)
                } else {
                    TodoListView(todoItems: $tasksTodoItems, additionalSubheadingStyle: .footnote, additionalSubheadingColor: .blue)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    TripDetailView(
        trip: Trip(
            name: "My cool adventure",
            detail: "Where are we going?",
            startDate: Date.distantPast,
            endDate: Date.now,
            members: ["", ""],
            places: [],
            tasks: []))
}
