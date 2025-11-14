import SwiftUI

@main
struct jumping_time_appApp: App {
    
    // 1. Create the MotionDataProvider ONCE as a @StateObject
    @StateObject private var motionProvider = MotionDataProvider()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    ContentView()
                }
                Tab("Chart", systemImage: "chart.bar") {
                    ChartView()
                }
            }
            // 2. Inject it into the environment for all tabs
            .environmentObject(motionProvider)
        }
    }
}
