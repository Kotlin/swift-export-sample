import Testing
import Shared
import KotlinRuntime

// Features added to the Kotlin topic files after the initial split.
// Each test struct names the topic file it covers.

// A Swift implementation of the Kotlin Translator interface, conforming to KotlinBase directly
final class ShoutingTranslator: KotlinBase, Translator {
    var language: String { "Shouting" }

    func translate(word: String) -> String {
        word.uppercased()
    }
}

// Interfaces.kt: the Translator protocol and its implementations
struct TranslatorTests {

    @Test func kotlinTranslator() {
        let translator = defaultTranslator()
        #expect(translator.language == "Pig Latin")
        #expect(translator.translate(word: "hello") == "ellohay")
        // The default implementation maps over translate(word:)
        #expect(translator.translateAll(words: ["a", "b"]) == ["aay", "bay"])
        #expect(translateSentence(sentence: "swift export", translator: translator) == "[Pig Latin] wiftsay xporteay")
    }

    @Test func swiftTranslatorPassedToKotlin() {
        #expect(translateSentence(sentence: "swift export", translator: ShoutingTranslator()) == "[Shouting] SWIFT EXPORT")
        // Kotlin's default translateAll(words:) calls the Swift translate(word:)
        #expect(ShoutingTranslator().translateAll(words: ["a", "b"]) == ["A", "B"])
    }
}

// Basics.kt: the @ObjCName rename and the 1-argument formatPrice overload
struct BasicsAdditionsTests {

    @Test func objCNameRenamesTopLevelFunctions() {
        // Kotlin makeLoud(text:), exported as shout(text:)
        #expect(shout(text: "kotlin") == "KOTLIN")
    }

    @Test func formatPriceOverloadForTheDefaultValue() {
        #expect(formatPrice(amount: 9.99) == "9.99 EUR")
    }
}

// Classes.kt: Temperature.freezing, the StepCounter inner class and the AppInfo object
struct ClassesAdditionsTests {

    @Test func companionObjectProperties() {
        #expect(Temperature.Companion.shared.freezing.celsius == 0)
        #expect(Temperature.Companion.shared.freezing.fahrenheit == 32)
    }

    @Test func innerClassMutatesTheOuterInstance() {
        let counter = StepCounter()
        let step = StepCounter.Step(by: 5, outer__: counter)
        #expect(step.apply() == 5)
        #expect(step.by == 5)
        // The inner instance mutated the outer counter
        #expect(counter.value == 5)
        #expect(step.apply() == 10)
    }

    @Test func objectCallsTheExpectDeclaration() {
        #expect(AppInfo.shared.banner().hasPrefix("Swift Export sample on "))
    }
}

// Generics.kt: Box.describe
struct GenericsAdditionsTests {

    @Test func describeShowsTheErasedValue() {
        #expect(Box(value: Int32(3)).describe() == "Box(3)")
        #expect(boxOf(value: "text").describe() == "Box(text)")
    }
}

// Collections.kt: evensIn
struct CollectionsAdditionsTests {

    @Test func evensInFiltersEvenNumbers() {
        #expect(evensIn(range: 1...10) == [2, 4, 6, 8, 10])
    }
}

// Exceptions.kt: Wallet and its exception payload
struct ExceptionsAdditionsTests {

    @Test func walletThrowsWithAPayload() throws {
        let wallet = try Wallet(balance: 10)
        try wallet.pay(amount: 4)
        #expect(wallet.balance == 6)

        var caught: InsufficientFundsException?
        do {
            try wallet.pay(amount: 25)
        } catch let error as InsufficientFundsException {
            caught = error
        }
        #expect(caught?.missing == 19)
        // The failed payment did not change the balance
        #expect(wallet.balance == 6)
        #expect(throws: (any Error).self) { try Wallet(balance: -1) }
    }
}

// Coroutines.kt: Countdown sees Swift's task cancellation
struct CoroutinesAdditionsTests {

    @Test func countdownFinishes() async throws {
        let countdown = Countdown()
        #expect(try await countdown.run(from: 1) == 1)
        #expect(countdown.wasCancelled == false)
    }

    @Test func countdownSeesCancellation() async throws {
        let countdown = Countdown()
        let task = Task { try await countdown.run(from: 30) }
        try await Task.sleep(for: .milliseconds(200))
        task.cancel()
        await #expect(throws: CancellationError.self) { try await task.value }
        // The Kotlin object saw the cancellation and kept the flag for Swift
        #expect(countdown.wasCancelled)
    }
}

// Platform.kt: expect osName() collapses to one function, linked to each platform's actual
struct PlatformAdditionsTests {

    @Test func expectActualCollapsesToOneFunction() {
        #if os(macOS)
        #expect(osName().hasPrefix("Version"))
        #elseif os(iOS)
        #expect(osName() == "iOS")
        #endif
    }
}
