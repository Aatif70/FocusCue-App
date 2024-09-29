import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation: Double = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Use Color directly without conditional
                (colorScheme == .dark ? Color.black : Color(hex: "F8EDE3"))
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .font(.system(size: 80))
                        .foregroundColor(colorScheme == .dark ? .white : Color(hex: "4A4947"))
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                        .rotationEffect(.degrees(rotation))
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: rotation)
                    
                    Text("Tasks")
                        
                        .foregroundColor(colorScheme == .dark ? .pink : Color(.orange))
                        .font(.system(size: 50, weight: .light, design: .serif))
                            .italic()
                            .bold()
                           
                        
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.size = 0.8
                        self.opacity = 1
                    }
                    withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                        self.rotation = 0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


#Preview {
    SplashScreenView()
}
