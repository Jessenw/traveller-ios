//
//  ResizableSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

class ResizableSheetState: ObservableObject {
    @Published var size = CGSize.zero
    @Published var isFullscreen = false
    @Published var detents: [CGFloat] = [200]
    @Published var currentDetent = CGFloat(0)
}

struct ResizableSheet<Content: View>: View {
    @StateObject private var state = ResizableSheetState()
    @State private var originalSize: CGSize = .zero
    @State private var currentSize: CGSize = .zero
    @State private var offset: CGFloat = 0 // Drag offset
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(uiColor: .systemGray6))
                .frame(height: state.isFullscreen ? geometry.frame(in: .global).height : state.size.height)
                .overlay(alignment: .top) {
                    VStack {
                        if !state.isFullscreen {
                            dragIndicator
                        }
                        
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: offset)
                .animation(.interactiveSpring(), value: offset)
                .animation(.interactiveSpring(), value: state.isFullscreen)
                .gesture(dragGesture(geometry: geometry))
        }
        .environmentObject(state)
    }
    
    // MARK: - Drag
    private var dragIndicator: some View {
        let size = CGSize(width: 40, height: 5)
        
        return RoundedRectangle(cornerRadius: size.height / 2)
            .fill(Color.secondary)
            .frame(width: size.width, height: size.height)
            .padding(.top, 10)
    }
    
    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation.height
            }
            .onEnded { value in
                // Snap to nearest detent
                let currentDetent = state.currentDetent
                let sheetHeight = currentDetent - value.translation.height
                let nearestDetent = state.detents.min(
                    by: { abs($0 - sheetHeight) < abs($1 - sheetHeight) }
                ) ?? currentDetent
                state.currentDetent = nearestDetent
                offset = 0
            }
    }
}

#Preview {
    ResizableSheet {
        VStack {
            ForEach(0..<5) { i in
                Text("\(i)")
            }
        }
    }
}
