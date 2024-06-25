//
//  TodoListView.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TodoListView: View {
    @Binding var todoItems: [TodoItem]
    var additionalSubheadingStyle: Font = .subheadline
    var additionalSubheadingColor: Color = .gray

    var body: some View {
        List {
            ForEach($todoItems) { $item in
                TodoItemView(item: $item, additionalSubheadingStyle: additionalSubheadingStyle, additionalSubheadingColor: additionalSubheadingColor)
            }
        }
        .listStyle(PlainListStyle())
    }
}
