import SwiftUI
import Shared
import KotlinRuntime

/// A Swift implementation of the Kotlin `Translator` interface.
/// Implementing a Kotlin protocol requires inheriting `KotlinBase`.
final class ShoutingTranslator: KotlinBase, Translator {
    /// Every word Kotlin asked this Swift object to translate.
    private(set) var calls: [String] = []

    var language: String { "Shouting" }

    func translate(word: String) -> String {
        calls.append(word)
        return word.uppercased()
    }
}

struct InterfacesView: View {
    var body: some View {
        let kotlinTranslator = defaultTranslator()
        let swiftTranslator = ShoutingTranslator()
        let sentence = translateSentence(sentence: "swift export", translator: swiftTranslator)
        let swiftValidator = validator { input in input.count > 3 }

        FeatureScreen(
            title: "Interfaces",
            summary: "A Kotlin interface is a Swift protocol, used as `any Translator`. Default methods are inherited. A Swift class that inherits `KotlinBase` can implement the protocol and be passed back to Kotlin."
        ) {
            Section("Kotlin implementation") {
                DemoRow("defaultTranslator().translate(word: \"hello\")", kotlinTranslator.translate(word: "hello"))
                DemoRow("translateSentence(…, translator: kotlinTranslator)", translateSentence(sentence: "swift export", translator: kotlinTranslator))
            }
            Section("Swift implementation, called from Kotlin") {
                DemoRow("translateSentence(…, translator: ShoutingTranslator())", sentence)
                DemoRow("words Kotlin passed to the Swift translate(word:)", swiftTranslator.calls.joined(separator: ", "))
                DemoRow("swiftTranslator.translateAll (Kotlin default method)", swiftTranslator.translateAll(words: ["a", "b"]).joined(separator: " "))
            }
            Section("fun interface") {
                DemoRow("countValid(…, validator: nonEmptyValidator())", countValid(inputs: ["a", "", "b"], validator: nonEmptyValidator()))
                DemoRow("countValid(…, validator: validator { $0.count > 3 })", countValid(inputs: ["kotlin", "swift", "objc"], validator: swiftValidator))
            }
        }
    }
}
