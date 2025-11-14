import Combine
import CoreMotion
import Foundation

enum JumpState {
    case idle
    case monitoring
    case armed
    case inAir
    case landed
}

class MotionDataProvider: ObservableObject {

    private let motionProvider = CMMotionManager()

    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0

    @Published var accelerationHistory: [ChartPoint] = []

    @Published var jumpState: JumpState = .idle
    @Published var airTime: Double = 0.0
    @Published var jumpHeight: Double = 0.0
    @Published var currentMagnitude: Double = 0.0

    private var freeFallStartTime: Date?

    let g = 9.80665
    let propulsionThreshold = 1.5
    let freeFallThreshold = 0.4
    let landingThreshold = 1.5
    let resetThreshold = 1.0

    init() {}

    func startUpdates() {

        // REAL 100 Hz
        motionProvider.deviceMotionUpdateInterval = 1.0 / 100.0
        
        motionProvider.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            
            guard let self = self, let motion = data else { return }

            self.accX       = motion.userAcceleration.x
            self.accY       = motion.userAcceleration.y
            self.accZ       = motion.userAcceleration.z

            let magnitude = sqrt(
                self.accX * self.accX +
                self.accY * self.accY +
                self.accZ * self.accZ
            )

            self.currentMagnitude = magnitude

            // ------------- APPEND TO HISTORY -------------
            let newPoint = ChartPoint(
                time: Date(),
                x: self.accX,
                y: self.accY,
                z: self.accZ,
                magnitude: magnitude
            )

            self.accelerationHistory.append(newPoint)
            if self.accelerationHistory.count > 100 {
                self.accelerationHistory.removeFirst()
            }

            // ------------- PROCESS CURRENT SAMPLE -------------
            self.runJumpLogic(magnitude: magnitude)
        }
    }

    func startMonitoring() {
        print("--- MONITORING ---")
        self.airTime = 0.0
        self.jumpHeight = 0.0
        self.jumpState = .monitoring
    }

    func stopMonitoring() {
        print("--- IDLE ---")
        self.jumpState = .idle
        self.airTime = 0.0
        self.jumpHeight = 0.0
    }

    private func runJumpLogic(magnitude: Double) {

        guard self.jumpState != .idle else { return }

        switch jumpState {

        case .monitoring:
            if magnitude > propulsionThreshold {
                print("PROPULSION DETECTED → armed")
                jumpState = .armed
            }

        case .armed:
            if magnitude < freeFallThreshold {
                print("FREE FALL DETECTED → inAir")
                freeFallStartTime = Date()
                jumpState = .inAir
            }

        case .inAir:
            if magnitude > landingThreshold {

                guard let start = freeFallStartTime else {
                    jumpState = .monitoring
                    return
                }

                let t_air = Date().timeIntervalSince(start)
                let height = (g * pow(t_air, 2)) / 8.0

                airTime = t_air
                jumpHeight = height

                print("LANDING DETECTED → landed")
                print("Air Time = \(t_air)")
                print("Jump Height = \(height)")

                jumpState = .landed
            }

        case .landed:
            if magnitude < resetThreshold {
                print("RESET → monitoring")
                jumpState = .monitoring
            }

        case .idle:
            break
        }
    }
}

struct ChartPoint: Identifiable, Equatable {
    var id: UUID = UUID()
    var time: Date
    var x: Double
    var y: Double
    var z: Double
    var magnitude: Double
}
