//
//  ResizableSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

class ResizableSheetState: ObservableObject {
    @Published var size: CGSize = .zero
}

struct ResizableSheet<Content: View>: View {
    @StateObject private var state = ResizableSheetState()
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .bottom
    @State private var originalSize: CGSize = .zero
    @State private var currentSize: CGSize = .zero
    
    let content: Content
    
    private let cornerRadius: CGFloat = 20
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: state.size.height)
                    .overlay(alignment: .top) {
                        content
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    }
            }
            .offset(y: calculateOffset(geometry: geometry))
        }
        .environmentObject(state)
        .frame(height: state.size.height) // Initial height
    }
    
    private func calculateOffset(geometry: GeometryProxy) -> CGFloat {
        let originalHeight = originalSize.height
        let newHeight = originalHeight * scale
        let difference = newHeight - originalHeight
        
        switch anchor {
        case .top:
            return 0
        case .bottom:
            return -difference
        default:
            return 0
        }
    }
}

#Preview {
    ResizableSheet {
        VStack {
            ForEach(0..<5) { i in
                HStack {
                    Text("\(i)")
                    Spacer()
                }
            }
        }
    }
}
