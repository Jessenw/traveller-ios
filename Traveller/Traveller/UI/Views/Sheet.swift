////
////  Sheet.swift
////  Traveller
////
////  Created by Jesse Williams on 11/07/2024.
////
//
//import SwiftUI
//
//struct HeaderSizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}
//
//struct ContentSizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}
//
//struct Sheet<Header: View, Content: View>: View {
//    @State private var scale: CGFloat = 1.0
//    @State private var anchor: UnitPoint = .top
//    @State private var headerSize: CGSize = .zero
//    @State private var contentSize: CGSize = .zero
//    
//    private let cornerRadius: CGFloat = 40
//    
//    let header: Header?
//    let content: Content?
//    
//    init(
//        @ViewBuilder header: () -> Header?,
//        @ViewBuilder content: () -> Content?
//    ) {
//        self.header = header()
//        self.content = content()
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Spacer()
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .foregroundStyle(Color(.systemGroupedBackground))
//                    .frame(
//                        width: geometry.size.width,
//                        height: headerSize.height * scale
//                    )
//                    .overlay {
//                        VStack {
//                            // MARK: - Header
//                            if let header {
//                                header
//                                    .padding()
//                                    .background(
//                                        GeometryReader { geo in
//                                            Color.clear
//                                                .preference(key: HeaderSizePreferenceKey.self, value: geo.size)
//                                        }
//                                            .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//                                    )
//                                    .onPreferenceChange(HeaderSizePreferenceKey.self, perform: { size in
//                                        let _ = print("Header size: \(size)")
//                                        headerSize = size
//                                    })
//                            }
//                            
//                            // MARK: - Content
//                            if let content {
//                                content
//                                    .padding()
//                                    .background(
//                                        GeometryReader { geo2 in
//                                            Color.clear
//                                                .preference(key: ContentSizePreferenceKey.self, value: geo2.size)
//                                        }
//                                            .border(.green, width: 3)
//                                    )
//                                    .onPreferenceChange(ContentSizePreferenceKey.self, perform: { size in
//                                        let _ = print("Content size: \(size)")
//                                        contentSize = size
//                                    })
//                            }
//                            Spacer()
//                        }
//                        .frame(height: headerSize.height + contentSize.height)
//                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
//                        .padding()
//                    }
//            }
//            .offset(y: calculateOffset(geometry: geometry))
//        }
//        .border(.blue, width: 3)
//        .frame(height: headerSize.height) // Initial size
//        .onTapGesture {
//            withAnimation(.spring()) {
//                anchor = anchor == .top ? .bottom : .top
//                let collapsedScale = headerSize.height / 100
//                let expandedScale = (headerSize.height + contentSize.height) / 100
//                scale = scale == collapsedScale ? expandedScale : collapsedScale
//            }
//        }
//    }
//    
//    private func calculateOffset(geometry: GeometryProxy) -> CGFloat {
//        let originalHeight = headerSize.height
//        let newHeight = originalHeight * scale
//        let difference = newHeight - originalHeight
//        
//        switch anchor {
//        case .top:
//            return 0
//        case .bottom:
//            return -difference
//        case .center:
//            return -difference / 2
//        default:
//            return 0
//        }
//    }
//}
//
//#Preview {
//    Sheet {
//        HStack {
//            Text("Header")
//                .font(.title)
//            Spacer()
//            Button(
//                action: {}, 
//                label: {
//                    Image(systemName: "multiply.circle.fill")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                }
//            )
//            .buttonStyle(PlainButtonStyle())
//        }
//    } content: {
//        VStack {
//            ForEach(0..<5) { i in
//                HStack {
//                    Text("\(i)")
//                    Spacer()
//                }
//            }
//        }
//    }
//}
