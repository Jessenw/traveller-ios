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

struct MeasureSizeModifier<Key: PreferenceKey>: ViewModifier where Key.Value == CGSize {
    
    let callback: (_ size: Key.Value) -> Void
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: Key.self, value: geometry.size)
            }
        )
        .onPreferenceChange(Key.self) { size in
            print("\(Key.self) size: \(size)")
            callback(size)
        }
    }
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
    
    var currentHeight: CGFloat {
        anchor == .top
        ? headerSize.height
        : headerSize.height + contentSize.height
    }
    
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
                .overlay {
                    VStack {
                        // MARK: - Header
                        if let header {
                            header
                                .padding()
                                .modifier(MeasureSizeModifier<HeaderSizePreferenceKey> { size in
                                    headerSize = size
                                })
                        }
                        
                        // MARK: - Content
                        if let content {
                            content
                                .padding()
                                .modifier(MeasureSizeModifier<ContentSizePreferenceKey> { size in
                                    contentSize = size
                                })
                        }
                    }
                    .offset(y: calculateOffset(geometry: geometry))
                    .frame(height: currentHeight)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .padding()
                }
            
        }
        .frame(width: 200, height: headerSize.height) // Initial size
        .onTapGesture {
            withAnimation(.spring()) {
                let originalScale = headerSize.height
                let targetScale = (headerSize.height + contentSize.height)
                let expandedScale = targetScale / originalScale
                scale = scale == 1.0 ? expandedScale : 1.0
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
        default:
            return 0
        }
    }
}
