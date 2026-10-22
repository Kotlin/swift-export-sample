import Testing
import Shared

// Swift implementation of a Kotlin interface, passed back to Kotlin
final class FrenchGreeting: GreetingBase, Greeting {
    var language: String { "French" }

    func greet(name: String) -> String { "Bonjour, \(name)!" }
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
        let all: [any Greeting] = greetings() + [FrenchGreeting()]
        #expect(greetEveryone(greetings: all, name: "Kodee") == ["Hello, Kodee!", "Hallo, Kodee!", "Bonjour, Kodee!"])
        // The Kotlin default implementation of greetAll calls the Swift greet
        #expect(FrenchGreeting().greetAll(names: ["A"]) == ["Bonjour, A!"])
    }

    @Test func functionalInterfaces() {
        #expect(validateAll(validator: notEmptyValidator(), inputs: ["", "x"]) == [false, true])
        // A Swift closure becomes an implementation of the Kotlin fun interface
        let shortInput = validator { $0.count < 3 }
        #expect(shortInput.validate(input: "ok"))
        #expect(!shortInput.validate(input: "too long"))
    }
}
