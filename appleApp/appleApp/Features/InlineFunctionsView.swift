import SwiftUI
import Shared

struct InlineFunctionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Inline & reified",
            summary: "An `inline` function is exported like a regular one, and its lambda parameters are escaping Swift closures; `crossinline` and `noinline` change nothing. A function with a `reified` type parameter is not exported, and neither is the `KClass` alternative. Export a wrapper with a concrete type, like `stringsIn(items:)`."
        ) {
            Section("Inline") {
                DemoRow("countMatching(numbers: [1, 2, 3, 4]) { $0 % 2 == 0 }", countMatching(numbers: [1, 2, 3, 4]) { $0 % 2 == 0 })
                DemoRow(#"greeter(name: { "Swift" })()"#, greeter(name: { "Swift" })())
                DemoRow("Int32(7).squared", Int32(7).squared)
            }
            Section("Reified") {
                DemoRow("filterType(items:)", "not exported — reified type parameter")
                DemoRow("filterByClass(items:type:)", "unavailable — KClass is not supported")
                DemoRow(#"stringsIn(items: ["Kotlin", Int32(2), "Swift", nil])"#, stringsIn(items: ["Kotlin", Int32(2), "Swift", nil]).joined(separator: ", "))
            }
        }
    }
}
