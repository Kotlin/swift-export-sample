import SwiftUI
import Shared

struct ReceiverLambdasView: View {
    var body: some View {
        FeatureScreen(
            title: "Lambdas with receiver",
            summary: "A lambda with receiver is a Swift closure whose first parameter is the receiver: `ShoppingList.() -> Unit` becomes `(ShoppingList) -> Void`, and `String.(Int) -> String` becomes `(String, Int32) -> String`. Swift has no implicit `this`, so the closure calls members on `$0`."
        ) {
            Section("Builders") {
                DemoRow(#"shoppingList { $0.add(item: "milk"); $0.add(item: "bread") }"#, shoppingList { $0.add(item: "milk"); $0.add(item: "bread") }.joined(separator: ", "))
                DemoRow("breakfast() — the same builder called from Kotlin", breakfast().joined(separator: ", "))
            }
            Section("Receiver and parameters") {
                DemoRow(#"numbered(words: ["Kotlin", "Swift"]) { word, number in "\(number). \(word)" }"#, numbered(words: ["Kotlin", "Swift"]) { word, number in "\(number). \(word)" }.joined(separator: ", "))
                DemoRow(#"surroundWith(marker: "*")("bold")"#, surroundWith(marker: "*")("bold"))
            }
        }
    }
}
