import SwiftUI
import Shared

struct GenericsView: View {
    var body: some View {
        let box = boxedGreeting()

        FeatureScreen(
            title: "Generics",
            summary: "Type parameters are erased: `fun <T> kindOf(value: T)` takes `(any _KotlinBridgeable)?`. Swift strings, arrays and numbers can be passed directly and keep their Kotlin type."
        ) {
            Section("Generic functions") {
                DemoRow("kindOf(value: \"str\")", kindOf(value: "str"))
                DemoRow("kindOf(value: Int32(7))", kindOf(value: Int32(7)))
                DemoRow("kindOf(value: [1, 2, 3] as [Int32])", kindOf(value: [1, 2, 3] as [Int32]))
                DemoRow("kindOf(value: 7) — a bare literal is not Int32", kindOf(value: 7))
            }
            Section("Generic classes") {
                DemoRow("boxedGreeting().value as? String", box.value as? String ?? "nil")
                DemoRow("Box(value: Int32(3)).describe()", Box(value: Int32(3)).describe())
            }
        }
    }
}
