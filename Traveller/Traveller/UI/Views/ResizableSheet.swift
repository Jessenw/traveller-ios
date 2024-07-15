//
//  ResizableSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

class ResizableSheetState: ObservableObject {
    @Published var size: CGSize = .zero
    @Published var detents: [CGFloat] = [CGFloat(200), CGFloat(400), 600].sorted()
    @Published var currentDetent: CGFloat = 0
}

struct ResizableSheet<Content: View>: View {
    @StateObject private var state = ResizableSheetState()
    
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .bottom
    @State private var originalSize: CGSize = .zero
    @State private var currentSize: CGSize = .zero
    @State private var offset: CGFloat = 0
    
    let content: Content
    
    private let cornerRadius: CGFloat = 20
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: state.size.height)
                    .overlay(alignment: .top) {
                        VStack {
                            dragIndicator

                            content
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                    }
            }
            .frame(height: state.currentDetent)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: offset)
            .animation(.interactiveSpring(), value: offset)
            .gesture(dragGesture(geometry: geometry))
            .offset(y: calculateOffset(geometry: geometry))
        }
        .environmentObject(state)
        .frame(height: state.size.height) // Initial height
    }
    
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
                    let sheetHeight = state.currentDetent - value.translation.height
                    let nearestDetent = state.detents.min(by: { abs($0 - sheetHeight) < abs($1 - sheetHeight) }) ?? state.currentDetent
                    state.currentDetent = nearestDetent
                    offset = 0
                }
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
