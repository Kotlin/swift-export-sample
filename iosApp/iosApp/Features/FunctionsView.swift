import SwiftUI
import Shared

struct FunctionsView: View {
    var body: some View {
        FeatureScreen(
            title: "Functions",
            summary: "Top-level Kotlin functions are global Swift functions with argument labels from the Kotlin parameter names. Overloads share one name; Swift picks one by the argument type."
        ) {
            Section("Top-level functions and overloads") {
                DemoRow("greet(name: \"Swift\")", greet(name: "Swift"))
                DemoRow("describe(value: 42 as Int32)", describe(value: 42 as Int32))
                DemoRow("describe(value: 4.2)", describe(value: 4.2))
                DemoRow("describe(value: \"text\")", describe(value: "text"))
            }
            Section("vararg → variadic parameter") {
                DemoRow("total(numbers: 1, 2, 3, 4)", total(numbers: 1, 2, 3, 4))
            }
            Section("@ObjCName(swiftName = \"shout\") fun makeLoud") {
                DemoRow("shout(text: \"quiet\")", shout(text: "quiet"))
            }
            Section("Default arguments are not exported") {
                DemoRow("formatPrice(amount: 9.99, currency: \"USD\")", formatPrice(amount: 9.99, currency: "USD"))
                DemoRow("formatPrice(amount: 9.99) — explicit Kotlin overload", formatPrice(amount: 9.99))
            }
        }
    }
}
