import SwiftUI
import Shared
import CryptoKit

struct FunctionTypesView: View {
    var body: some View {
        // CryptoKit is Swift-only; Kotlin gets access to it through a closure
        let platform = Platform(md5hasher: { input in
            Insecure.MD5.hash(data: Data(input.utf8)).map { String(format: "%02x", $0) }.joined()
        })
        let shouter = makeMultiplier(factor: 10)

        FeatureScreen(
            title: "Function types",
            summary: "Kotlin function types are Swift closures in both directions: Swift passes a closure into Kotlin, and Kotlin returns one to Swift. A class with a function-type property is the injection point for Swift-only APIs such as CryptoKit."
        ) {
            DemoRow("applyTwice(value: 3) { $0 * 2 }", applyTwice(value: 3) { $0 * 2 })
            DemoRow("makeMultiplier(factor: 10)(7)", shouter(7))
            DemoRow(#"transformAll(items: ["a", "b"]) { $0.uppercased() }"#, transformAll(items: ["a", "b"]) { $0.uppercased() }.joined(separator: ", "))
            DemoRow(#"reverseImportExample(platform: Platform(md5hasher: { … }))"#, reverseImportExample(platform: platform))
        }
    }
}
