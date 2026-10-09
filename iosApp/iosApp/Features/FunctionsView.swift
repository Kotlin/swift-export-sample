import SwiftUI
import Shared

struct FunctionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Functions",
            summary: "Top-level Kotlin functions are global Swift functions with argument labels from the Kotlin parameter names. Overloads share one name; Swift picks one by the argument type."
        ) {
            DemoRow("greet(name: \"Swift\")", greet(name: "Swift"))
            DemoRow("describe(value: 42 as Int32)", describe(value: 42 as Int32))
            DemoRow("describe(value: 4.2)", describe(value: 4.2))
            DemoRow("describe(value: \"text\")", describe(value: "text"))
        }
    }
}
