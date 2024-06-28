//
//  TaskRow.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TaskRow: View {
    @Binding var task: Task

    var body: some View {
        let isChecked = task.isChecked
        
        HStack {
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
                Text(task.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(task.additionalSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(task.imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        }
        .padding(.vertical, 8)
    }
}
