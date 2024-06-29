//
//  TaskRow.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftData
import SwiftUI

struct TaskRow: View {
    @Environment(\.modelContext) private var modelContext
    
    var task: Task

    var body: some View {
        let isChecked = task.isChecked
        
        HStack {
            // Checked button
            Button(action: {
                task.isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                if let notes = task.notes {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
