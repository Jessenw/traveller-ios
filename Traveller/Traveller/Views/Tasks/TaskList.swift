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
                    let (completed, notCompleted) = trip.tasks.separate { $0.isChecked }
                    
                    // Not completed tasks
                    Section {
                        ForEach(notCompleted) { TaskRow(task: $0) }
                    } header: {
                        HStack(alignment: .center) {
                            Text("Outstanding")
                            
                            Spacer()
                            
                            // Create task
                            CreateTaskButton(showingCreateDialog: $showingCreateDialog)
                        }
                    }
                    
                    // Completed tasks
                    Section("Completed") {
                        ForEach(completed) { TaskRow(task: $0) }
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
    
    private static let size: CGFloat = 24
    
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
                        .frame(width: Self.size, height: Self.size)
                }
            }
        }
    }
}
