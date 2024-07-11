//
//  Sheet.swift
//  Traveller
//
//  Created by Jesse Williams on 11/07/2024.
//

import SwiftUI

struct Sheet<Header: View, Content: View>: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .top
    
    private let cornerRadius: CGFloat = 40
    
    let header: Header?
    let content: Content
    
    init(
        @ViewBuilder header: () -> Header?,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Spacer()
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(Color(.systemGroupedBackground))
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * scale
                    )
                    .overlay {
                        VStack {
                            if let header {
                                header.padding()
                            }
                            content
                            Spacer()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .padding()
                    }
            }
            .offset(y: calculateOffset(geometry: geometry))
        }
        .frame(width: .infinity, height: 100) // Initial size
        .onTapGesture {
            withAnimation(.spring()) {
                anchor = anchor == .top ? .bottom : .top
                scale = scale == 1.0 ? 2.0 : 1.0
            }
        }
    }
    
    private func calculateOffset(geometry: GeometryProxy) -> CGFloat {
         let originalHeight = geometry.size.height
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

#Preview {
    Sheet {
        HStack {
            Text("Header")
                .font(.title)
            Spacer()
            Button(
                action: {}, 
                label: {
                    Image(systemName: "multiply")
                }
            )
        }
    } content: {
        LazyVStack {
            ForEach(0..<5) { i in
                Text("\(i)")
            }
        }
    }
}
