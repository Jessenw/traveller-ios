//
//  TaskList.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TaskList: View {
    @Binding var tasks: [Task]

    var body: some View {
        List {
            ForEach($tasks) { $task in
                TaskRow(task: $task)
            }
        }
        .listStyle(PlainListStyle())
    }
}
