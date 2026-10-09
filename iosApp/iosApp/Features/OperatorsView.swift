import SwiftUI
import Shared

struct OperatorsView: View {
    var body: some View {
        let coffee = Money(cents: 350)
        let cake = Money(cents: 425)
        let playlist = Playlist(songs: ["Intro", "Theme", "Outro"])

        FeatureScreen(
            title: "Operators",
            summary: "Kotlin operator functions are Swift operators: `plus` is `+`, `times` is `*`, `compareTo` gives `<`/`>`, `get` is a subscript and `contains` is `~=`."
        ) {
            DemoRow("coffee + cake", "\(coffee + cake)")
            DemoRow("coffee * 3", "\(coffee * 3)")
            DemoRow("coffee < cake", coffee < cake)
            DemoRow("playlist[1]", playlist[1])
            DemoRow("playlist ~= \"Outro\"", playlist ~= "Outro")
        }
    }
}
