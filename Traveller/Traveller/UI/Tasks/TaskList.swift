//
//  TaskList.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI
import SwiftData

struct TaskList: View {
    @Environment(\.modelContext) private var modelContext

    let tripId: PersistentIdentifier

    // State
    @State private var showingCreateDialog = false

    var body: some View {
        List {
            if let trip: Trip = modelContext.registeredModel(for: tripId) {
                let (completed, notCompleted) = trip.tasks.separate { $0.isChecked }
                
                outstandingTasksSection(tasks: notCompleted)
                completedTasksSection(tasks: completed)
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $showingCreateDialog) {
            CreateTaskDialog(tripId: tripId)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                createButton
            }
        }
        .navigationTitle("Todos")
    }
    
    // MARK: - Subviews
    private func outstandingTasksSection(tasks: [Task]) -> some View {
        Section("Outstanding") {
            ForEach(tasks) { TaskRow(task: $0) }
        }
    }
    
    private func completedTasksSection(tasks: [Task]) -> some View {
        Section("Completed") {
            ForEach(tasks) { TaskRow(task: $0) }
        }
    }
    
    private var createButton: some View {
        Button(action: {
            showingCreateDialog = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
        }
    }
}
