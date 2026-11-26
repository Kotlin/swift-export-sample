import Testing
import Shared

struct InlineFunctionsTests {

    @Test func inlineFunctionsAreRegularFunctions() {
        var calls = 0
        #expect(countMatching(numbers: [1, 2, 3, 4]) { calls += 1; return $0 % 2 == 0 } == 2)
        #expect(calls == 4)
        #expect(Int32(7).squared == 49)
    }

    @Test func crossinlineLambdaRunsLater() {
        // The returned closure keeps the Swift closure, so it really is escaping
        var asked = 0
        let greet = greeter(name: { asked += 1; return "Swift" })
        #expect(asked == 0)
        #expect(greet() == "Hello, Swift!")
        #expect(asked == 1)
    }

    @Test func reifiedFunctionsNeedAConcreteWrapper() {
        // filterType<T>(items:) is not exported; stringsIn(items:) calls it with T = String
        #expect(stringsIn(items: ["Kotlin", Int32(2), "Swift", nil]) == ["Kotlin", "Swift"])
    }
}
