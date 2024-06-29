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
    @Query var tasks: [Task]
    @State var showingCreateDialog: Bool = false
    
    var tripId: PersistentIdentifier

    var body: some View {
        ZStack {
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task)
                }
            }
            .listStyle(PlainListStyle())
            
            // Create task button
            CreateTaskButton(showingCreateDialog: $showingCreateDialog)
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
        .padding()
    }
}
