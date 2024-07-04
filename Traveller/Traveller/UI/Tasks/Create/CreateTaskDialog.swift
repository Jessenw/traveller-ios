//
//  CreateTaskDialog.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import SwiftUI
import SwiftData

struct CreateTaskDialog: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var deadline: Date?
    
    var tripId: PersistentIdentifier

    var body: some View {
        if let trip: Trip = modelContext.registeredModel(for: tripId) {
            NavigationView {
                Form {
                    Section() {
                        TextField("Name", text: $title)
                        TextField("Description (Optional)", text: $notes)
                    }

                    Button(action: { createTask(trip: trip) }) {
                        Text("Create")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(title.isEmpty)
                }
                .navigationBarTitle("New Task", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }

    private func createTask(trip: Trip) {
        let newTask = Task(
            title: title,
            notes: notes,
            deadline: deadline)
        
        trip.tasks.append(newTask)
        presentationMode.wrappedValue.dismiss()
    }
}
