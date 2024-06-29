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
    @State var showingCreateDialog: Bool = false
    
    var tripId: PersistentIdentifier

    var body: some View {
        ZStack {
            List {
                if let trip: Trip = modelContext.registeredModel(for: tripId) {
                    let tasks = trip.tasks
                    let seperatedTasks = trip.tasks.separate { $0.isChecked }
                    
                    // Not completed tasks
                    Section {
                        ForEach(seperatedTasks.notMatching) { task in
                            TaskRow(task: task)
                        }
                    } header: {
                        HStack(alignment: .center) {
                            Text("Outstanding")
                            Spacer()
                            CreateTaskButton(showingCreateDialog: $showingCreateDialog)
                        }
                    }
                    
                    // Completed tasks
                    Section("Completed") {
                        ForEach(seperatedTasks.matching) { task in
                            TaskRow(task: task)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .sheet(isPresented: $showingCreateDialog) {
            CreateTaskDialog(tripId: tripId)
        }
    }
}

fileprivate struct CreateTaskButton: View {
    @Binding var showingCreateDialog: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingCreateDialog = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}
