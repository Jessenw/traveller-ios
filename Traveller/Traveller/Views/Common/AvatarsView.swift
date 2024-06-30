//
//  AvatarsView.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import SwiftUI

struct AvatarsView: View {
    private let members: [Member]
    private let maxMembers: Int
    private static let avatarSize: CGFloat = 24
    
    init(members: [Member], maxMembers: Int = 4) {
        self.members = members
        self.maxMembers = maxMembers
    }
    
    var body: some View {
        if !members.isEmpty {
            HStack {
                ForEach(members.prefix(maxMembers)) { _ in
                    Circle()
                        .fill(Utilities.randomColor())
                        .frame(width: Self.avatarSize, height: Self.avatarSize)
                }
                if members.count > maxMembers {
                    Text("+ \(members.count - maxMembers) more")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    Group {
        AvatarsView(members: Array(repeating: Member(name: ""), count: 3))
        AvatarsView(members: Array(repeating: Member(name: ""), count: 5))
        AvatarsView(members: Array(repeating: Member(name: ""), count: 10))
    }
}
