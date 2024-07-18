//
//  ResizableSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

class ResizableSheetState: ObservableObject {
    // Sizing
    @Published var size: CGSize = .zero
    @Published var detents: [CGFloat] = [200]
    @Published var currentDetent: CGFloat = .zero
    @Published var isFullscreen: Bool = false
    
    // Header
    @Published var headerTitle: String?
    @Published var headerSubtitle: String?
    @Published var isHeaderButtonClose: Bool = false
    @Published var headerButtonTapped: () -> Void = {}
}

struct ResizableSheet<Content: View>: View {
    @State private var originalSize: CGSize = .zero
    @State private var currentSize: CGSize = .zero
    @State private var offset: CGFloat = 0 // Drag offset
    @State private var headerButtonRotation: Double = 0
    
    @EnvironmentObject var state: ResizableSheetState
    
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(.background)
                .frame(
                    height: state.isFullscreen
                    ? geometry.frame(in: .global).height
                    : state.size.height)
                .overlay(alignment: .top) {
                    VStack {
                        if !state.isFullscreen {
                            dragIndicator
                        }
                        
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                if let headerTitle = state.headerTitle {
                                    Text(headerTitle)
                                        .font(.title)
                                }
                                if let headerSubtitle = state.headerSubtitle {
                                    Text(headerSubtitle)
                                        .font(.caption)
                                }
                            }
                            Spacer()
                            headerButton
                                .animation(.spring, value: state.isFullscreen)
                        }
                        .padding()
                        
                        content()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .offset(y: offset)
                .animation(.spring, value: offset)
                .animation(.spring, value: state.isFullscreen)
                .gesture(dragGesture(geometry: geometry))
        }
    }
    
    private var headerButton: some View {
        Button(
            action: {
                state.isHeaderButtonClose.toggle()
                state.headerButtonTapped()
            },
            label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .rotationEffect(
                        .degrees(state.isHeaderButtonClose ? 45 : 0),
                        anchor: .center)
                    .animation(
                        .interactiveSpring,
                        value: state.isHeaderButtonClose)
            }
        )
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
