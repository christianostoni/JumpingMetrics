import SwiftUI
struct ContentView: View {
    
    // --- STEP 2: Add all your state variables ---
    @EnvironmentObject var motionProvider: MotionDataProvider
    
    //@State private var jumpState: JumpState = .idle
    @State private var jumpStartTime: Date?
    @State private var lastJumpTime: TimeInterval = 0.0

    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Jumping Time")
                .font(.system(size: 40).bold())
            
            // --- UI for Results ---
            VStack {
                Text("0.0")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                Text("Jump Time")
                    .font(.headline)
            }

            VStack {
                Text(String(format: "%.2f m", motionProvider.jumpHeight))
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                Text("Jump Height")
                    .font(.headline)
            }
            
            // --- UI for Tuning ---
            Text("Live Magnitude: \(motionProvider.currentMagnitude)")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Spacer()
            
            // --- UI for the Button ---
            Button(motionProvider.jumpState == .idle ? "Start Monitoring" : "Stop Monitoring") {
                motionProvider.startMonitoring()
            }
            .font(.title2.bold())
            .padding()
            .background(motionProvider.jumpState == .idle ? .blue : .red)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .padding()
            
        }.onAppear{motionProvider.startUpdates()}
    }
}
               
#Preview {
    ContentView()
        .environmentObject(MotionDataProvider())
}
