import Charts
import SwiftUI

struct ChartView: View {
    // This receives the shared data provider from the App level
    @EnvironmentObject var motionProvider: MotionDataProvider
    @State var showX: Bool = true
    @State var showY: Bool = true
    @State var showZ: Bool = true
    @State var showMagnitude: Bool = true

    var body: some View {
        VStack {
            Text("Live Motion Analysis")
                .font(.headline)
                .padding(.top)

            Chart(motionProvider.accelerationHistory) { point in
                
                // --- FIX: Removed 'unit: .second' from all x-values ---

                if showX {
                    LineMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.x)
                    )
                    .foregroundStyle(by: .value("Series", "X-Axis"))
                    
                    PointMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.x)
                    )
                    .foregroundStyle(by: .value("Series", "X-Axis"))
                    .opacity(0.4)
                }

                if showY {
                    LineMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.y)
                    )
                    .foregroundStyle(by: .value("Series", "Y-Axis"))
                    
                    PointMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.y)
                    )
                    .foregroundStyle(by: .value("Series", "Y-Axis"))
                    .opacity(0.4)
                }
                
                if showZ {
                    LineMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.z)
                    )
                    .foregroundStyle(by: .value("Series", "Z-Axis"))
                    
                    PointMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.z)
                    )
                    .foregroundStyle(by: .value("Series", "Z-Axis"))
                    .opacity(0.4)
                }

                if showMagnitude {
                    LineMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.magnitude)
                    )
                    .foregroundStyle(by: .value("Series", "Magnitude"))
                    
                    PointMark(
                        x: .value("Time", point.time), // <-- FIX HERE
                        y: .value("Acceleration", point.magnitude)
                    )
                    .foregroundStyle(by: .value("Series", "Magnitude"))
                    .opacity(0.4)
                }
            }
            .chartLegend(position: .top, alignment: .center)
            .padding()

            HStack {
                Toggle("X", isOn: $showX)
                Toggle("Y", isOn: $showY)
                Toggle("Z", isOn: $showZ)
                Toggle("Mag", isOn: $showMagnitude)
            }
            .toggleStyle(.button)
            .padding(.horizontal)

            Spacer()
        }
        .onAppear {
            motionProvider.startUpdates()
        }
    }
}

#Preview {
    ChartView()
        .environmentObject(MotionDataProvider())
}
