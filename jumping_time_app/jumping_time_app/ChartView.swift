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
            Text("X-Axis Acceleration (Live)")
                .font(.headline)

            // Create the chart from the history array
            Chart(motionProvider.accelerationHistory) { point in

                if showX {
                    LineMark(
                        x: .value("Time", point.time, unit: .second),  // Use .second to format the Date axis
                        y: .value("Acceleration", point.x)
                    ).foregroundStyle(by: .value("x", "blue"))

                    PointMark(
                        x: .value("Time", point.time, unit: .second),
                        y: .value("Acceleration", point.x)
                    )
                    .foregroundStyle(.blue)
                }

                if showY {
                    LineMark(
                        x: .value("Time", point.time, unit: .second),  // Use .second to format the Date axis
                        y: .value("Acceleration", point.y)
                    ).foregroundStyle(by: .value("y", "pink"))

                    PointMark(
                        x: .value("Time", point.time, unit: .second),
                        y: .value("Acceleration", point.y)
                    )
                    .foregroundStyle(.pink)

                }
                if showZ {
                    LineMark(
                        x: .value("Time", point.time, unit: .second),  // Use .second to format the Date axis
                        y: .value("Acceleration", point.z)
                    ).foregroundStyle(by: .value("z", "yellow"))

                    PointMark(
                        x: .value("Time", point.time, unit: .second),
                        y: .value("Acceleration", point.z)
                    )

                }

                if showMagnitude {
                    LineMark(
                        x: .value("Time", point.time, unit: .second),  // Use .second to format the Date axis
                        y: .value("Acceleration", point.magnitude)
                    ).foregroundStyle(by: .value("magnitude", "red"))

                    // Optional: Add points to see the data

                    PointMark(
                        x: .value("Time", point.time, unit: .second),
                        y: .value("Acceleration", point.magnitude)
                    )
                    .foregroundStyle(.red)
                }

            }
            .chartYScale(domain: -2.0...2.0)  // Set a fixed Y-axis (optional)
            .padding()

            HStack {
                Toggle("X", isOn: $showX)
                Toggle("Y", isOn: $showY)
                Toggle("Z", isOn: $showZ)
                Toggle("Mag", isOn: $showMagnitude)
            }
            .toggleStyle(.button) // <-- This makes them look like buttons
            .padding(.horizontal)

            Spacer()  // Pushes the chart to the top
        }
    }
}

#Preview {
    // This preview will work once you set up the EnvironmentObject
    ChartView()
        .environmentObject(MotionDataProvider())  // Add this for preview
}
