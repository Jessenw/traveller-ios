//
//  CreateTripDialog.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI

struct CreateTripDialog: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var trips: [Trip]
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
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
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
        let newTrip = Trip(name: name, detail: detail, startDate: includeDates ? startDate : nil, endDate: includeDates ? endDate : nil)
        trips.append(newTrip)
        presentationMode.wrappedValue.dismiss()
    }
}
