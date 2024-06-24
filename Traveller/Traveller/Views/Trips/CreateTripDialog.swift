//
//  CreateTripDialog.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftData
import SwiftUI

struct CreateTripDialog: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var name: String = ""
    @State private var detail: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var includeDates: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Name", text: $name)
                    TextField("Description (Optional)", text: $detail)
                }

                Section {
                    Toggle(isOn: $includeDates) {
                        Text("Include Dates")
                    }
                    if includeDates {
                        DateSelectionForm(startDate: $startDate, endDate: $endDate)
                    }
                }

                Button(action: createTrip) {
                    Text("Create")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(name.isEmpty)
            }
            .navigationBarTitle("New Trip", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func createTrip() {
        let newTrip = Trip(
            name: name,
            detail: detail,
            startDate: includeDates ? startDate : nil,
            endDate: includeDates ? endDate : nil,
            members: [String].init(repeating: "", count: Int.random(in: 1...5)))
        modelContext.insert(newTrip)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DateSelectionForm: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .onChange(of: startDate) { _, newValue in
                    // Ensure the end date is later than the start date
                    if (newValue > endDate) {
                        endDate = newValue
                    }
                }
            DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
        }
    }
}
