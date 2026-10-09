import SwiftUI
import Shared

struct AnnotationsView: View {
    var body: some View {
        FeatureScreen(
            title: "Annotations & docs",
            summary: "KDoc becomes Swift documentation (option-click `vowelCount` in Xcode). `@Deprecated` becomes `@available(*, deprecated)`, and with level ERROR the function is unavailable. `@HiddenFromObjC` removes a declaration from Swift."
        ) {
            DemoRow("vowelCount(text: \"Swift Export\")", vowelCount(text: "Swift Export"))
            DemoRow("countVowels(text:)", "deprecated — Xcode shows a warning with the replacement")
            DemoRow("vowels(text:)", "unavailable — calling it is a compile error")
            DemoRow("kotlinOnlyHelper()", "not exported")
        }
    }
}
