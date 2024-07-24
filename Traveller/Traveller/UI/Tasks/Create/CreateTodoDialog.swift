//
//  CreateTodoDialog.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import SwiftUI
import SwiftData

struct CreateTodoDialog: View {
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

                    Button(action: { createTodo(trip: trip) }) {
                        Text("Create")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(title.isEmpty)
                }
                .navigationBarTitle("New Todo", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }

    private func createTodo(trip: Trip) {
        let newTodo = Todo(
            title: title,
            notes: notes,
            deadline: deadline)
        
        trip.todos.append(newTodo)
        presentationMode.wrappedValue.dismiss()
    }
}
