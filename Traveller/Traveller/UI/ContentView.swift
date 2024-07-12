import SwiftUI

struct ContentView: View {
    var body: some View {
        ResizableAnchoredShape()
    }
}
    
#Preview {
    ContentView()
}
    
struct ResizableAnchoredShape: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .top

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * scale
                )
                .offset(y: calculateOffset(geometry: geometry))
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
