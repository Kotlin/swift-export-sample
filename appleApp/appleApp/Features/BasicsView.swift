import SwiftUI
import Shared

struct BasicsView: View {
    var body: some View {
        FeatureScreen(
            title: "Basics",
            summary: "Top-level declarations become Swift globals: `val`/`var` become `var` with and without a setter, functions keep their labels and overloads. Kotlin `Int` is `Int32`, `Char` is a UTF-16 code unit, `Any` accepts most Swift values, `Unit` is `Void` and `Nothing` is `Never`. Default argument values are not exported, so `Basics.kt` adds a 1-argument `formatPrice` overload for the common case."
        ) {
            Section("Top-level properties") {
                DemoRow("SAMPLE_NAME", SAMPLE_NAME)
                DemoRow("answer", answer)
                CounterRow()
            }
            Section("Primitive types") {
                DemoRow(
                    "primitives(bool: true, byte: 1, short: 2, int: 3, long: 4, float: 5.5, double: 6.5)",
                    primitives(bool: true, byte: 1, short: 2, int: 3, long: 4, float: 5.5, double: 6.5)
                )
                DemoRow("unsigned(value: 21)", unsigned(value: 21))
                DemoRow(#"charCode(char: "A".utf16.first!)"#, charCode(char: "A".utf16.first!))
            }
            Section("Optionals") {
                DemoRow(#"greet(name: "Swift")"#, greet(name: "Swift"))
                DemoRow("greet(name: nil)", greet(name: nil))
                DemoRow("findPositive(value: 7)", findPositive(value: 7))
                DemoRow("findPositive(value: -7)", findPositive(value: -7))
            }
            Section("Overloads and vararg") {
                DemoRow("describe(value: Int32(42))", describe(value: Int32(42)))
                DemoRow("describe(value: Double(3.14))", describe(value: Double(3.14)))
                DemoRow(#"describe(value: "kotlin")"#, describe(value: "kotlin"))
                DemoRow("sumAll(numbers: 1, 2, 3)", sumAll(numbers: 1, 2, 3))
            }
            Section("Default arguments: overloads in Swift") {
                DemoRow("formatPrice(amount: 9.99)", formatPrice(amount: 9.99))
                DemoRow(#"formatPrice(amount: 9.99, currency: "USD")"#, formatPrice(amount: 9.99, currency: "USD"))
            }
            Section("Any, Unit, Nothing") {
                DemoRow(#"typeOf(value: "text")"#, typeOf(value: "text"))
                DemoRow("typeOf(value: [1, 2, 3])", typeOf(value: [1, 2, 3]))
                DemoRow("doNothing()", "returns Void")
                DemoRow("fail(message:)", "exported as `func fail(message: String) -> Never`")
            }
            Section("@ObjCName renames in Swift") {
                DemoRow(#"shout(text: "kotlin")  // Kotlin: makeLoud(text:)"#, shout(text: "kotlin"))
            }
        }
    }
}

/// The top-level `counter` is mutable, so its result is kept in `@State`.
private struct CounterRow: View {
    @State private var value = counter

    var body: some View {
        HStack {
            DemoRow("increment()", value)
            Spacer()
            Button("Run") {
                value = increment()
            }
        }
    }
}
