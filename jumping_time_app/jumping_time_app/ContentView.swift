import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var motionProvider: MotionDataProvider
    
    @State private var animatePulse = false
    @State private var clicked = false
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.black
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // --- TITLE ---
                Text("Jump Analyzer")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            Color.white.opacity(0.25),
                            lineWidth: 12
                        )
                        .frame(width: 260, height: 260)
                        .scaleEffect(1 + CGFloat(motionProvider.currentMagnitude) * 0.30)
                        .animation(.easeOut(duration: 0.30), value: motionProvider.currentMagnitude)

                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: animatePulse ? 300 : 260,
                               height: animatePulse ? 300 : 260)
                        .blur(radius: animatePulse ? 25 : 5)
                        .opacity(motionProvider.jumpState == .monitoring ? 1 : 0)
                        .animation(.easeInOut(duration: 1).repeatForever(), value: animatePulse)
                    
                    // Button itself
                    Button {
                        motionProvider.startMonitoring()
                        animatePulse.toggle()
                        clicked = true
                    } label: {
                        Text(buttonTitle())
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(
                                Circle().fill(buttonColor())
                            )
                            .shadow(color: buttonColor().opacity(0.6),
                                    radius: 20, y: 10)
                    }
                    .scaleEffect(1 + CGFloat(motionProvider.currentMagnitude) * 0.12)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: motionProvider.currentMagnitude)
                }
                
                Spacer()
                
                // --- JUMP HEIGHT RESULT ---
                if motionProvider.jumpState == .idle && clicked {
                    VStack(spacing: 6) {
                        Text(String(format: "%.2f m", motionProvider.jumpHeight))
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Jump Height")
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.headline)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeOut(duration: 0.3), value: motionProvider.jumpState)
                }
                
                Spacer()
            }
        }
        .onAppear {
            motionProvider.startUpdates()
        }
    }
    
    // UI HELPERS
    private func buttonTitle() -> String {
        switch motionProvider.jumpState {
        case .idle: return "Start"
        case .monitoring: return "Monitoring…"
        case .inAir: return "In Air!"
        case .landed: return "Done"
        default: return "Start"
        }
    }
    
    private func buttonColor() -> Color {
        switch motionProvider.jumpState {
        case .idle: return .blue
        case .monitoring: return .indigo
        case .inAir: return .orange
        case .landed: return .green
        default: return .blue
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MotionDataProvider())
}
