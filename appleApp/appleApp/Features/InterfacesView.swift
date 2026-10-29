import SwiftUI
import Shared
import KotlinRuntime

/// A Swift implementation of the Kotlin `Translator` interface.
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
        let swiftTranslator = ShoutingTranslator()
        let sentence = translateSentence(sentence: "swift export", translator: swiftTranslator)

        FeatureScreen(
            title: "Interfaces",
            summary: "A Kotlin interface is a Swift protocol, used as `any Translator`; default methods are inherited. A Swift class can implement it by inheriting `KotlinBase` with the protocol, and Kotlin calls back into the Swift implementation."
        ) {
            Section("Kotlin implementations") {
                DemoRow("greetings().map(\\.language)", greetings().map(\.language).joined(separator: ", "))
                DemoRow(#"greetEveryone(greetings: greetings(), name: "Swift")"#, greetEveryone(greetings: greetings(), name: "Swift").joined(separator: " "))
                DemoRow(#"defaultTranslator().translate(word: "hello")"#, defaultTranslator().translate(word: "hello"))
                DemoRow(#"translateSentence(sentence: "swift export", translator: defaultTranslator())"#, translateSentence(sentence: "swift export", translator: defaultTranslator()))
            }
            Section("Swift implementation, called from Kotlin") {
                DemoRow(#"translateSentence(…, translator: ShoutingTranslator())"#, sentence)
                DemoRow("words Kotlin passed to the Swift translate(word:)", swiftTranslator.calls.joined(separator: ", "))
                DemoRow(#"swiftTranslator.translateAll(words: ["a", "b"]) — Kotlin default method"#, swiftTranslator.translateAll(words: ["a", "b"]).joined(separator: " "))
            }
            Section("fun interface") {
                DemoRow(#"validateAll(validator: notEmptyValidator(), inputs: ["a", "", "b"])"#, validateAll(validator: notEmptyValidator(), inputs: ["a", "", "b"]).map(String.init).joined(separator: ", "))
                DemoRow(#"validateAll(validator: validator { $0.count > 3 }, inputs: ["kotlin", "swift", "objc"])"#, validateAll(validator: validator { $0.count > 3 }, inputs: ["kotlin", "swift", "objc"]).map(String.init).joined(separator: ", "))
            }
        }
    }
}
