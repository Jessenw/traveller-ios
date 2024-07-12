import SwiftUI

struct ContentView: View {
    var body: some View {
        ResizableShape()
    }
}
    
#Preview {
    ContentView()
}
    
struct ResizableShape: View {
    @State private var scale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .center
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(
                    width: geometry.size.width * scale,
                    height: geometry.size.height * scale
                )
                .position(
                    x: geometry.size.width * anchor.x,
                    y: geometry.size.height * anchor.y
                )
        }
        .frame(width: 200, height: 100) // Initial size
        .onTapGesture {
            withAnimation(.spring()) {
                scale = scale == 1.0 ? 1.5 : 1.0
                anchor = anchor == .center ? .topLeading : .center
            }
        }
    }
}
