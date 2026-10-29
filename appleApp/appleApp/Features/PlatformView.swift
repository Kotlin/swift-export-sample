import SwiftUI
import Shared

struct PlatformView: View {
    var body: some View {
        FeatureScreen(
            title: "Platform code",
            summary: "Platform-specific Kotlin lives in `iosMain` and `macosMain`, and the exported package keeps each source set's declarations under `#if os(...)`. An `expect`/`actual` pair becomes one ordinary Swift function, linked to the actual implementation of the platform being built."
        ) {
            Section("expect / actual") {
                DemoRow("osName() — expect in commonMain, actual per source set", osName())
            }
            Section("Per-source-set declarations") {
                #if os(iOS)
                DemoRow(#"platformName() — iosMain"#, platformName())
                DemoRow("currentDevice().model — a UIKit type in the API", currentDevice().model)
                #elseif os(macOS)
                DemoRow(#"platformName() — macosMain"#, platformName())
                #endif
            }
            Section("iosMain declarations are iOS-only in Swift") {
                #if os(iOS)
                DemoRow("iosBar() — :shared's iosMain", iosBar())
                #else
                DemoRow("iosBar() — :shared's iosMain", "not compiled on this platform")
                #endif
            }
        }
    }
}
