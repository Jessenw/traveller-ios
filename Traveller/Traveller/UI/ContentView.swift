import SwiftUI

struct ContentView: View {
    var body: some View {
        ResizableAnchoredShapeSheet {
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
}
    
#Preview {
    ContentView()
}

struct HeaderSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
    
struct ResizableAnchoredShapeSheet<Header: View, Content: View>: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .top
    
    let header: Header?
    let content: Content?
    
    @State private var headerSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    private let cornerRadius: CGFloat = 40
    
    init(
        @ViewBuilder header: () -> Header?,
        @ViewBuilder content: () -> Content?
    ) {
        self.header = header()
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * scale
                )
                .offset(y: calculateOffset(geometry: geometry))
                .overlay {
                    VStack {
                        // MARK: - Header
                        if let header {
                            header
                                .padding()
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: HeaderSizePreferenceKey.self, value: geo.size)
                                    }
                                        .border(.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                                )
                                .onPreferenceChange(HeaderSizePreferenceKey.self, perform: { size in
                                    let _ = print("Header size: \(size)")
                                    headerSize = size
                                })
                        }
                        
                        // MARK: - Content
                        if let content {
                            content
                                .padding()
                                .background(
                                    GeometryReader { geo2 in
                                        Color.clear
                                            .preference(key: ContentSizePreferenceKey.self, value: geo2.size)
                                    }
                                        .border(.green, width: 3)
                                )
                                .onPreferenceChange(ContentSizePreferenceKey.self, perform: { size in
                                    let _ = print("Content size: \(size)")
                                    contentSize = size
                                })
                        }
                        Spacer()
                    }
                    .frame(height: headerSize.height + contentSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .padding()
                }
        }
        .frame(width: 200, height: 100) // Initial size
        .onTapGesture {
            withAnimation(.spring()) {
                scale = scale == 1.0 ? 1.5 : 1.0
                anchor = anchor == .top ? .bottom : .top
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
