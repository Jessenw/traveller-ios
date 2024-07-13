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
            callback(size)
        }
    }
}

struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ResizableAnchoredShapeSheet<Header: View, Content: View>: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .top
    @State private var expanded = false
    
    let header: Header?
    let content: Content?
    
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
                    .fill(Color.blue)
                    .frame(height: currentSize.height)
                    .overlay(alignment: .top) {
                        VStack {
                            // MARK: - Header
                            if let header {
                                header.padding()
                            }
                            
                            // MARK: - Content
                            if let content, expanded {
                                content.padding([.horizontal, .bottom])
                            }
                        }
                        .modifier(MeasureSizeModifier<ContentSizePreferenceKey> { size in
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
        }
        .frame(width: 200, height: currentSize.height) // Initial height
        .onTapGesture {
            withAnimation(.spring()) {
                expanded.toggle()
                
                if expanded {
                    scale = currentSize.height / originalSize.height
                    anchor = .top
                } else {
                    scale = 1.0
                    anchor = .bottom
                }
                
                originalSize = currentSize
            }
        }
    }
}
