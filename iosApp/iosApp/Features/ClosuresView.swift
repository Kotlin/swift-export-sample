import SwiftUI
import Shared
import CryptoKit

struct ClosuresView: View {
    var body: some View {
        // CryptoKit is Swift-only; Kotlin gets access to it through a closure.
        let md5 = TextHasher(hash: { input in
            Insecure.MD5.hash(data: Data(input.utf8)).map { String(format: "%02x", $0) }.joined()
        })
        let shout = makeShouter()

        FeatureScreen(
            title: "Closures",
            summary: "Kotlin function types are Swift closures in both directions: Swift passes a closure into Kotlin, and Kotlin can return one."
        ) {
            DemoRow("fingerprint(text: \"kotlin\", hasher: md5)", fingerprint(text: "kotlin", hasher: md5))
            DemoRow("makeShouter()(\"hello\")", shout("hello"))
        }
    }
}
