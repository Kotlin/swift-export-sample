import SwiftUI
import Shared

struct GenericsView: View {
    var body: some View {
        let box = boxOf(value: "text")

        FeatureScreen(
            title: "Generics",
            summary: "Type parameters are erased: `fun <T> boxOf(value: T)` takes `(any _KotlinBridgeable)?`, and `Box<T>.value` is `(any _KotlinBridgeable)?`. Swift strings, arrays and numbers are passed directly and cast on the way out. `firstOrNull` shows the same erasure for a nullable generic list."
        ) {
            Section("Generic functions") {
                DemoRow(#"TypeChecker.shared.checkType(input: "str")"#, TypeChecker.shared.checkType(input: "str"))
                DemoRow("TypeChecker.shared.checkType(input: Int32(7))", TypeChecker.shared.checkType(input: Int32(7)))
                DemoRow("TypeChecker.shared.checkType(input: [1, 2, 3])", TypeChecker.shared.checkType(input: [1, 2, 3]))
                DemoRow(#"firstOrNull(items: ["a", nil]) as? String"#, firstOrNull(items: ["a", nil]) as? String)
            }
            Section("Generic classes") {
                DemoRow(#"boxOf(value: "text").value as? String"#, box.value as? String)
                DemoRow(#"box.map { ($0 as? String)?.uppercased() }.value as? String"#, box.map { ($0 as? String)?.uppercased() }.value as? String)
                DemoRow("Box(value: Int32(3)).describe()", Box(value: Int32(3)).describe())
            }
        }
    }
}
