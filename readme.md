# JumpingMetrics 🚀

![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-iOS_17+-lightgrey?style=flat-square)
![Framework](https://img.shields.io/badge/Framework-SwiftUI-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

**JumpingMetrics** is an iOS application that calculates vertical jump height and air time using the iPhone's internal sensors (accelerometer & gyroscope) via **CoreMotion**. 

It was developed as part of a coding challenge to replicate the functionality of an existing Indie Developer app ("My Jump 3") but with a twist: **using Physics instead of Computer Vision.**

## 🎯 The Goal
The original inspiration, *My Jump 3* by Carlos Balsalobre, uses high-speed camera footage to measure air time. My goal was to achieve similar results by tapping into the iPhone's raw sensor data, creating a solution that doesn't require setting up a camera or manual video analysis.

## 🛠 Tech Stack
* **Language:** Swift
* **UI Framework:** SwiftUI (Following Apple's Human Interface Guidelines)
* **Sensor Framework:** CoreMotion (`CMDeviceMotion`)
* **Visualization:** Swift Charts (Real-time data plotting)
* **Architecture:** MVVM (Model-View-ViewModel) with `ObservableObject`

## 📐 How It Works (The Physics)
Unlike standard pedometers, measuring a vertical jump requires precise high-frequency data (100Hz). The app uses a **State Machine** to detect the phases of a jump based on G-force magnitude.

### The Formula
The app calculates height ($h$) based on the measured Air Time ($t_{air}$) using kinematic equations for free fall:

$$h = \frac{g \cdot t_{air}^2}{8}$$

Where $g$ is standard gravity ($9.81 m/s^2$).

### The State Machine
1.  **Monitoring:** The app waits for a G-force spike (> 1.2G) indicating **Propulsion**.
2.  **The "Golden Signal":** It detects when `userAcceleration` magnitude drops to near zero (< 0.25G). This indicates **Free Fall** (Weightlessness). **The Timer Starts.**
3.  **Landing:** It waits for a massive impact spike (> 2.2G). **The Timer Stops.**
4.  **Cooldown:** The system resets once the sensor data stabilizes.

## 🚧 Challenges & Limitations
**"It works... mostly."**

Currently, the jump detection algorithm relies on **fixed thresholds** for G-force.
* ✅ If you jump with standard force and land firmly, it works perfectly.
* ⚠️ If you have a "soft" landing or a weak takeoff, the thresholds might miss the event.

**Future Improvement:**
To make this 100% robust, the fixed thresholds need to be replaced with a dynamic analysis function that calculates derivatives (maxima/minima) in real-time. (If you have PTSD from Calculus 1, you know the pain I am about to face 😅).

## 📦 Installation
1.  Clone the repo:
    ```bash
    git clone [https://github.com/christianostoni/JumpingMetrics.git](https://github.com/christianostoni/JumpingMetrics.git)
    ```
2.  Open `jumping_time_app.xcodeproj` in Xcode.
3.  Build and run on a **physical iPhone**.
    * *Note: CoreMotion data does not work correctly on the iOS Simulator. You need a real device to test the sensors.*

## 🎓 Learning Outcomes
This project was a deep dive into Apple's ecosystem:
* Mastered **CoreMotion** to separate Gravity from User Acceleration.
* Implemented **Swift Charts** for high-frequency live data visualization.
* Refined UI skills to match **Apple's HIG** (Human Interface Guidelines).

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Developed by Ostoni Christian*
