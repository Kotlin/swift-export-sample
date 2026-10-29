import SwiftUI

// Declarations that require an opt-in in Kotlin are Swift SPI
@_spi(com$github$jetbrains$swiftexport$ExperimentalSampleApi) import Shared

struct AnnotationsView: View {
    var body: some View {
        FeatureScreen(
            title: "Annotations & docs",
            summary: "KDoc becomes Swift documentation (option-click `documented(name:)` in Xcode). `@Deprecated` becomes `@available(*, deprecated)` and with level ERROR the function is unavailable. `@HiddenFromObjC` removes a declaration from Swift, and `@RequiresOptIn` declarations are imported as SPI, see the `@_spi` import above."
        ) {
            DemoRow(#"documented(name: "Swift")"#, documented(name: "Swift"))
            DemoRow(#"SwiftFriendlyName().run(21) — KotlinSpecificName().execute(_:)"#, SwiftFriendlyName().run(21))
            DemoRow(#"vowelCount(text: "Swift Export")"#, vowelCount(text: "Swift Export"))
            DemoRow("oldApi()", "deprecated — Xcode shows a warning with the replacement")
            DemoRow("vowels(text:)", "unavailable — level ERROR makes it a compile error to call")
            DemoRow("kotlinOnly()", "not exported — @HiddenFromObjC")
            DemoRow("experimentalGreeting()", experimentalGreeting())
        }
    }
}
