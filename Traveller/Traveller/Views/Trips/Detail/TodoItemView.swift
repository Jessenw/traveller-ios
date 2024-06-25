//
//  TodoItemView.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TodoItemView: View {
    @Binding var item: TodoItem
    var additionalSubheadingStyle: Font = .subheadline
    var additionalSubheadingColor: Color = .gray

    var body: some View {
        HStack {
            Button(action: {
                item.isChecked.toggle()
            }) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isChecked ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.subheading)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(item.additionalSubheading)
                    .font(additionalSubheadingStyle)
                    .foregroundColor(additionalSubheadingColor)
            }
            
            Spacer()
            
            Image(item.imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        }
        .padding(.vertical, 8)
    }
}
