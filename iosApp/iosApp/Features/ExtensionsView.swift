import SwiftUI
import Shared

struct ExtensionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Extensions",
            summary: "Extension functions and properties from the root package become Swift extensions, so they read the same as in Kotlin."
        ) {
            DemoRow("\"Hi\".repeated(times: 3)", "Hi".repeated(times: 3))
            DemoRow("\"Swift Export is neat\".wordCount", "Swift Export is neat".wordCount)
        }
    }
}
