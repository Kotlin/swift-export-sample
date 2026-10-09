import Testing
import Shared
import KotlinRuntime

// Swift implementation of a Kotlin interface, passed back to Kotlin
final class SwiftGreeting: KotlinBase, Greeting {
    var language: String { "Swift" }

    func greet(name: String) -> String { "Hello from Swift, \(name)!" }
}

struct InterfacesTests {

    @Test func protocols() {
        let all = greetings()
        #expect(all.map(\.language) == ["English", "German"])
        #expect(all[1].greet(name: "Welt") == "Hallo, Welt!")
        // Default implementation from the Kotlin interface
        #expect(all[0].greetAll(names: ["A", "B"]) == ["Hello, A!", "Hello, B!"])
    }

    @Test func swiftImplementationsOfKotlinInterfaces() {
        let all: [any Greeting] = greetings() + [SwiftGreeting()]
        #expect(greetEveryone(greetings: all, name: "Kodee") == ["Hello, Kodee!", "Hallo, Kodee!", "Hello from Swift, Kodee!"])
        // The Kotlin default implementation of greetAll calls the Swift greet
        #expect(SwiftGreeting().greetAll(names: ["A"]) == ["Hello from Swift, A!"])
    }

    @Test func functionalInterfaces() {
        #expect(validateAll(validator: notEmptyValidator(), inputs: ["", "x"]) == [false, true])
        // A Swift closure becomes an implementation of the Kotlin fun interface
        let shortInput = validator { $0.count < 3 }
        #expect(shortInput.validate(input: "ok"))
        #expect(!shortInput.validate(input: "too long"))
    }
}
