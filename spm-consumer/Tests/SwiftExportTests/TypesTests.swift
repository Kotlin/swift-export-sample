import Testing
import Shared

struct GenericsTests {

    @Test func genericsAreErased() {
        let box = boxOf(value: "text")
        #expect(box.value as? String == "text")
        let mapped = box.map { Int32(($0 as! String).count) }
        #expect(mapped.value as? Int32 == 4)
        #expect(firstOrNull(items: []) == nil)
    }

    @Test func genericFunctionsAcceptSwiftValues() {
        #expect(TypeChecker.shared.checkType(input: "str") == .IsString)
        #expect(TypeChecker.shared.checkType(input: Int32(1)) == .IsInt)
        #expect(TypeChecker.shared.checkType(input: [1, 2, 3]) == .IsList)
    }
}

struct CollectionsTests {

    @Test func collectionsAreSwiftCollections() {
        #expect(fibonacci(count: 7) == [0, 1, 1, 2, 3, 5, 8])
        #expect(uniqueWords(text: "Swift Kotlin swift") == ["swift", "kotlin"])
        #expect(wordLengths(words: ["Kotlin", "Swift"]) == ["Kotlin": 6, "Swift": 5])
        #expect(nestedLists() == [[1, 2], nil, [3]])
    }

    @Test func stdlibTypes() {
        // Arrays and other stdlib classes are Kotlin types from the KotlinStdlib module
        let bytes = bytesOf(text: "Kotlin")
        #expect(bytes.size == 6)
        #expect(bytes[0] == 75)
        #expect(checksum(bytes: bytes) == 625)
        let builder = ExportedKotlinPackages.kotlin.text.StringBuilder()
        #expect(buildGreeting(builder: builder, name: "Swift") == "Hello, Swift")
    }

    @Test func ranges() {
        #expect(digits() == 0...9)
        #expect(isAdult(age: 18))
    }
}

struct OperatorsTests {

    @Test func arithmeticAndComparison() {
        let a = Vector(x: 1, y: 2)
        let b = Vector(x: 3, y: 4)
        #expect((a + b).x == 4)
        #expect((b - a).y == 2)
        #expect((a * 2).y == 4)
        #expect((-a).x == -1)
        #expect(a < b)
    }

    @Test func subscriptsAndContains() {
        let grid = Grid(width: 2, height: 2)
        grid[3] = 7
        #expect(grid[3] == 7)
        #expect(grid.contains(value: 7))
    }

    @Test func invokeAndInfix() {
        let triple = Multiplier(factor: 3)
        #expect(triple(value: 5) == 15)
        #expect(Int32(2).power(exponent: 10) == 1024)
    }
}

struct ExtensionsTests {

    @Test func extensionsOnSwiftTypes() {
        #expect("hello".shout() == "HELLO!")
        #expect("ab".repeated(times: 3) == "ababab")
        #expect("Kotlin and Swift".wordCount == 3)
        #expect(Int32(4).isEven())
        let missing: String? = nil
        #expect(missing.orDefault() == "default")
    }
}

struct FunctionTypesTests {

    @Test func closures() {
        #expect(applyTwice(value: 3) { $0 * $0 } == 81)
        #expect(makeMultiplier(factor: 4)(5) == 20)
        #expect(transformAll(items: ["a", "b"]) { $0.uppercased() } == ["A", "B"])
    }

    @Test func swiftImplementationOfKotlinDependency() {
        let platform = Platform(md5hasher: { "hash of \($0)" })
        #expect(reverseImportExample(platform: platform) == "hash of example")
    }
}
