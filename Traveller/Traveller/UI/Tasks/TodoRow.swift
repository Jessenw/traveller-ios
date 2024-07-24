//
//  TodoRow.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftData
import SwiftUI

struct TodoRow: View {
    @Environment(\.modelContext) private var modelContext
    
    var todo: Todo

    var body: some View {
        let isChecked = todo.isChecked
        
        HStack {
            // Checked button
            Button(action: {
                withAnimation { todo.isChecked.toggle() }
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .secondary)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(todo.title)
                    .font(.headline)
                if let notes = todo.notes {
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
