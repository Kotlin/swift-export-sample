import SwiftUI
import Shared

struct TypesView: View {
    var body: some View {
        FeatureScreen(
            title: "Types & nullability",
            summary: "Kotlin `Int` is `Int32` and `Long` is `Int64`. Unsigned types map to `UInt32`/`UInt64`, `Char` to a UTF-16 code unit. Nullable types are plain Swift optionals. `Unit` is `Void` and `Nothing` is `Never`."
        ) {
            Section("Numbers") {
                DemoRow("sizes(byte: 1, short: 2, int: 3, long: 4)", sizes(byte: 1, short: 2, int: 3, long: 4))
                DemoRow("largestUInt()", largestUInt())
                DemoRow("largestULong()", largestULong())
            }
            Section("Char") {
                let letter = firstLetter(text: "Kotlin")
                DemoRow("firstLetter(text: \"Kotlin\")", "\(letter) = \(Character(Unicode.Scalar(letter)!))")
            }
            Section("Nullability") {
                DemoRow("parseAge(text: \"42\")", parseAge(text: "42"))
                DemoRow("parseAge(text: \"forty\")", parseAge(text: "forty"))
                DemoRow("lengthOrZero(text: nil)", lengthOrZero(text: nil))
            }
            Section("Unit and Nothing") {
                DemoRow("log(message:) returns", "\(type(of: log(message: "hi from Swift")))")
                DemoRow("unreachable(reason:)", "-> Never, so Swift knows the code after it is dead")
            }
        }
    }
}
