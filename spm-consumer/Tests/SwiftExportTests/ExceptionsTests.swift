import Testing
import Shared

struct ExceptionsTests {

    @Test func throwingFunctions() throws {
        #expect(try parseAge(input: "42") == 42)
        // Kotlin exceptions are Swift errors
        #expect(throws: ValidationException.self) { try parseAge(input: "forty two") }
        do {
            _ = try parseAge(input: "-1")
        } catch let error as ValidationException {
            #expect(error.message == "Age cannot be negative")
        }
    }

    @Test func throwingConstructors() {
        #expect(throws: (any Error).self) { try PositiveNumber(value: -1) }
    }
}
