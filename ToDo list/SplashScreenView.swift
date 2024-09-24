import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .font(.system(size: 50))
                        .foregroundStyle(.blue.gradient)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
//                        .rotationEffect(.degrees(rotation))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: rotation)
                    
                    Text("Tasks")
                        .font(.system(size: 40, weight: .bold))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        self.rotation = 360
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
