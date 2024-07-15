//
//  ResizableAnchoredSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

struct ResizableAnchoredSheet<Header: View, Content: View>: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .bottom
    @State private var expanded = false
    
    let header: Header?
    let content: Content?
    
    @State private var maxSize: CGSize = .zero
    @State private var originalSize: CGSize = .zero
    @State private var currentSize: CGSize = .zero
    
    private let cornerRadius: CGFloat = 20
    
    init(
        @ViewBuilder header: () -> Header?,
        @ViewBuilder content: () -> Content?
    ) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(uiColor: .systemGray6))
                    .frame(height: currentSize.height)
                    .overlay(alignment: .top) {
                        VStack {
                            // MARK: - Header
                            if let header {
                                header
                                    .padding()
                            }
                            
                            // MARK: - Content
                            if let content, expanded {
                                content
                                    .padding([.horizontal, .bottom])
                            }
                        }
                        .modifier(MeasureSizeModifier<ResizableAnchoredSheetSizePreferenceKey> { size in
                            // Don't animate on first layout
                            if currentSize == .zero {
                                currentSize = size
                            }
                            withAnimation {
                                currentSize = size
                            }
                        })
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    }
            }
            .offset(y: calculateOffset(geometry: geometry))
        }
        .frame(height: currentSize.height) // Initial height
        .onTapGesture {
            withAnimation(.spring()) {
                expanded.toggle()
            }
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
        case .center:
            return -difference / 2
        default:
            return 0
        }
    }
}

struct ResizableAnchoredSheetSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

#Preview {
    ResizableAnchoredSheet {
        HStack {
            Text("Header")
                .font(.title)
            Spacer()
            Button(
                action: {},
                label: {
                    Image(systemName: "multiply.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            )
            .buttonStyle(PlainButtonStyle())
        }
    } content: {
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
