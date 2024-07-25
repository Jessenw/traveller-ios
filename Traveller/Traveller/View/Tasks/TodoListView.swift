//
//  TodoListView.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.modelContext) private var modelContext

    let tripId: PersistentIdentifier

    // State
    @State private var showingCreateDialog = false

    var body: some View {
        List {
            if let trip: Trip = modelContext.registeredModel(for: tripId) {
                let (completed, notCompleted) = trip.todos.separate { $0.isChecked }
                
                todosSection(title: "Outstanding", todos: notCompleted)
                todosSection(title: "Completed", todos: completed)
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showingCreateDialog) {
            CreateTodoDialog(tripId: tripId)
        }
        .navigationTitle("Todos")
    }
    
    // MARK: - Subviews
    private func todosSection(title: String, todos: [Todo]) -> some View {
        Section(title) {
            ForEach(todos) { TodoRow(todo: $0) }
        }
    }
}
