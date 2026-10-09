import SwiftUI
import Shared

struct PlatformView: View {
    var body: some View {
        FeatureScreen(
            title: "Platform code",
            summary: "`expect fun platformName()` is declared in commonMain and implemented in iosMain with UIKit. Swift sees one ordinary function."
        ) {
            DemoRow("platformName()", platformName())
        }
    }
}
