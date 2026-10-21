import Testing
import Shared

struct BasicsTests {

    @Test func topLevelDeclarations() {
        #expect(SAMPLE_NAME == "Swift Export Sample")
        #expect(answer == 42)
        #expect(sharedFunction() == 15)

        counter = 10
        #expect(increment() == 11)
        #expect(counter == 11)
    }

    @Test func primitiveTypes() {
        let result = primitives(bool: true, byte: 1, short: 2, int: 3, long: 4, float: 5.5, double: 6.5)
        #expect(result == "true 1 2 3 4 5.5 6.5")
        #expect(unsigned(value: 21) == UInt64(42))
        #expect(charCode(char: "A".utf16.first!) == 65)
    }

    @Test func nullability() {
        #expect(greet(name: nil) == "Hello, stranger!")
        #expect(greet(name: "Kotlin") == "Hello, Kotlin!")
        #expect(findPositive(value: 5) == 5)
        #expect(findPositive(value: -5) == nil)
    }

    @Test func overloadsAndVarargs() {
        #expect(describe(value: Int32(1)) == "Int 1")
        #expect(describe(value: 1.5) == "Double 1.5")
        #expect(describe(value: "one") == "String \"one\"")
        #expect(sumAll(numbers: 1, 2, 3, 4) == 10)
    }

    @Test func defaultArgumentsMustBePassedExplicitly() {
        #expect(formatPrice(amount: 9.99, currency: "EUR") == "9.99 EUR")
    }

    @Test func anyType() {
        #expect(typeOf(value: "text") == "String")
        #expect(typeOf(value: Int32(1)) == "Int")
        #expect(typeOf(value: [1, 2, 3]) == "List")
    }

    @Test func nestedPackage() {
        // Declarations outside of `rootPackage` keep their namespace
        #expect(nested.nestedPackageFunction() == "nested")
        #expect(nested.NestedPackageClass().hello() == "Hello from a nested package")
        #expect(ExportedKotlinPackages.com.github.jetbrains.swiftexport.nested.nestedPackageFunction() == "nested")
    }
}
