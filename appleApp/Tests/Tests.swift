import XCTest
#if canImport(UIKit)
import UIKit
#endif
// Declarations that require an opt-in in Kotlin are Swift SPI
@_spi(com$github$jetbrains$swiftexport$ExperimentalSampleApi) import Shared
import ModuleA
import ModuleB
import ModuleC
// The stub of the hidden :module-d Engine class is declared in ModuleD
import ModuleD
// Members inherited from stdlib classes, such as Throwable.message, live in KotlinStdlib
import KotlinStdlib
// KotlinBase, which Swift implementations of Kotlin interfaces inherit, lives in KotlinRuntime
import KotlinRuntime
// The hidden Koin dependency is exported as a stub module
import IoInsertKoinKoinCore

// These tests run on iOS and macOS against the modules embedded into the app by `embedSwiftExportForXcode`.
// spm-consumer/Tests checks the same features against the exported Swift package.

// MARK: - Modules

final class ModulesTests: XCTestCase {

    func testLibraryConfiguredModule() {
        // :module-a sets its own `moduleName` and `rootPackage`
        XCTAssertEqual(ClassFromA(name: "A").hello(), "Hello from A")
        XCTAssertEqual(moduleAFunction(), 5)
        XCTAssertEqual(useClassFromA().hello(), "Hello from class_A")
        #if os(iOS)
        XCTAssertEqual(iosModuleABar(), 54321)
        #endif
    }

    func testConsumerConfiguredModule() {
        // :module-b is configured by :shared
        XCTAssertEqual(ClassFromB(name: "B").hello(), "Hello from B")
        XCTAssertEqual(moduleBFunction(), 10)
        XCTAssertEqual(useClassFromB().hello(), "Hello from class_B")
        #if os(iOS)
        XCTAssertEqual(iosModuleBBar(), 12345)
        #endif
    }

    func testExposedImplementationDependency() {
        // :module-c is an implementation dependency with SwiftExportVisibility.EXPOSED
        XCTAssertEqual(moduleCFunction(), 7)
        let tracker = analytics()
        tracker.track(event: Event(name: "test", properties: ["key": "value"]))
        XCTAssertEqual(tracker.trackedEvents().map(\.name), ["test"])
    }

    func testHiddenDependency() {
        // :module-d is HIDDEN: Engine is an empty stub, but Car can still inherit from it
        let car = Car()
        XCTAssertEqual(car.drive(), "Engine started, driving")
        let engine: ExportedKotlinPackages.com.github.jetbrains.moduled.Engine = car
        XCTAssertTrue(engine === car)
    }

    func testNestedPackage() {
        // Declarations outside of `rootPackage` keep their namespace
        XCTAssertEqual(nested.nestedPackageFunction(), "nested")
        XCTAssertEqual(nested.NestedPackageClass().hello(), "Hello from a nested package")
        XCTAssertEqual(ExportedKotlinPackages.com.github.jetbrains.swiftexport.nested.nestedPackageFunction(), "nested")
    }
}

// MARK: - Platform

final class PlatformTests: XCTestCase {

    #if os(iOS)
    func testIosMainDeclarations() {
        XCTAssertEqual(iosBar(), 125)
        XCTAssertTrue(platformName().hasPrefix(UIDevice.current.systemName))
    }

    func testPlatformTypes() {
        // UIKit types used in iosMain signatures are the real UIKit types in Swift
        let device: UIDevice = currentDevice()
        XCTAssertEqual(device.model, UIDevice.current.model)
    }
    #elseif os(macOS)
    func testMacosMainDeclarations() {
        XCTAssertTrue(platformName().hasPrefix("macOS"))
    }
    #endif
}

// MARK: - Basics

final class BasicsTests: XCTestCase {

    func testTopLevelDeclarations() {
        XCTAssertEqual(SAMPLE_NAME, "Swift Export Sample")
        XCTAssertEqual(answer, 42)
        XCTAssertEqual(sharedFunction(), 15)

        counter = 10
        XCTAssertEqual(increment(), 11)
        XCTAssertEqual(counter, 11)
    }

    func testPrimitiveTypes() {
        let result = primitives(bool: true, byte: 1, short: 2, int: 3, long: 4, float: 5.5, double: 6.5)
        XCTAssertEqual(result, "true 1 2 3 4 5.5 6.5")
        XCTAssertEqual(unsigned(value: 21), UInt64(42))
        // Char is a UTF-16 code unit
        XCTAssertEqual(charCode(char: "A".utf16.first!), 65)
    }

    func testNullability() {
        XCTAssertEqual(greet(name: nil), "Hello, stranger!")
        XCTAssertEqual(greet(name: "Kotlin"), "Hello, Kotlin!")
        XCTAssertEqual(findPositive(value: 5), 5)
        XCTAssertNil(findPositive(value: -5))
    }

    func testOverloadsAndVarargs() {
        XCTAssertEqual(describe(value: Int32(1)), "Int 1")
        XCTAssertEqual(describe(value: 1.5), "Double 1.5")
        XCTAssertEqual(describe(value: "one"), "String \"one\"")
        XCTAssertEqual(sumAll(numbers: 1, 2, 3, 4), 10)
    }

    func testContextParameters() {
        // Context parameters are passed first, without a label
        let log = AuditLog()
        XCTAssertEqual(placeOrder(log, item: "book"), "Order for book placed")
        XCTAssertEqual(log.entries(), ["Ordered book"])
    }

    func testDefaultArgumentsMustBePassedExplicitly() {
        XCTAssertEqual(formatPrice(amount: 9.99, currency: "EUR"), "9.99 EUR")
    }

    func testAnyType() {
        XCTAssertEqual(typeOf(value: "text"), "String")
        XCTAssertEqual(typeOf(value: Int32(1)), "Int")
        XCTAssertEqual(typeOf(value: [1, 2, 3]), "List")
    }
}

// MARK: - Classes

/// Swift subclass of an exported open Kotlin class
final class TestCircle: Shared.Shape {
    let radius: Double

    init(radius: Double) {
        self.radius = radius
        super.init(name: "Circle")
    }

    override func area() -> Double {
        Double.pi * radius * radius
    }
}

/// Swift subclass that overrides an open property and an open method, and calls `super`
final class LoudFormatter: MessageFormatter {
    override var prefix: String { "Swift" }

    override func format(message: String) -> String {
        super.format(message: message).uppercased()
    }
}

final class ClassesTests: XCTestCase {

    func testConstructorsNestedAndInnerClasses() {
        let myClass = MyClass(property: 5)
        XCTAssertEqual(MyClass(text: "four").property, 4)
        XCTAssertEqual(sum(a: myClass, b: MyNested(nestedProperty: 6)), 11)
        XCTAssertEqual(MyClass.Inner(outer__: myClass).outerProperty(), 5)
    }

    func testInheritance() {
        let square = Square(side: 2)
        XCTAssertEqual(square.area(), 4)
        XCTAssertEqual(square.describe(), "Square: Rectangle with area 4.0")
        // Square is a Rectangle subclass in Swift too
        let rectangle: Rectangle = square
        XCTAssertEqual(rectangle.area(), 4)
    }

    func testSwiftSubclassIsCalledFromKotlin() {
        let shapes: [Shared.Shape] = [TestCircle(radius: 1), Rectangle(width: 2, height: 3)]
        XCTAssertEqual(totalArea(shapes: shapes), Double.pi + 6, accuracy: 0.0001)
        XCTAssertTrue(describeAll(shapes: shapes)[0].hasPrefix("Circle with area 3.14"))
    }

    func testSwiftOverridesOfPropertiesAndSuper() {
        // Kotlin calls the Swift overrides, and `super` reads the overridden `prefix`
        XCTAssertEqual(formatWith(formatter: LoudFormatter(), message: "hello"), "[SWIFT] HELLO")
        XCTAssertEqual(formatWith(formatter: MessageFormatter(), message: "hello"), "[Kotlin] hello")
    }

    func testObjectsAndCompanions() {
        let start = Counter.shared.value
        XCTAssertEqual(Counter.shared.increment(), start + 1)
        XCTAssertTrue(Counter.shared === Counter.shared)

        let boiling = Temperature.Companion.shared.fromCelsius(value: 100)
        XCTAssertEqual(boiling.fahrenheit, 212)
    }

    func testDataClasses() {
        let point = Point(x: 1, y: 2)
        let moved = point.copy(x: 4, y: 6)
        XCTAssertEqual(moved.x, 4)
        // equals, hashCode and toString are available as ==, hashValue and description
        XCTAssertEqual(point, Point(x: 1, y: 2))
        XCTAssertEqual(point.hashValue, Point(x: 1, y: 2).hashValue)
        XCTAssertEqual(point.description, "Point(x=1, y=2)")
        XCTAssertEqual(point.distanceTo(other: moved), 5)
    }

    func testValueClasses() {
        XCTAssertEqual(email(value: "user@example.com").domain, "example.com")
    }

    func testPropertyVisibility() {
        let account = Account(owner: "Jane")
        account.deposit(amount: 100)
        XCTAssertEqual(account.balance, 100)
        account.nickname = "JD"
        XCTAssertEqual(account.nickname, "JD")
        XCTAssertEqual(account.formattedBalance, "Jane: 100")
    }

    func testRenamedDeclarations() {
        // @ObjCName(swiftName = ...) renames the class, the function and the parameter label
        XCTAssertEqual(SwiftFriendlyName().run(21), 42)
    }
}

// MARK: - Interfaces

/// Swift implementation of a Kotlin interface, passed back to Kotlin
final class SwiftGreeting: KotlinBase, Greeting {
    var language: String { "Swift" }

    func greet(name: String) -> String { "Hello from Swift, \(name)!" }
}

final class InterfacesTests: XCTestCase {

    func testProtocols() {
        let all = greetings()
        XCTAssertEqual(all.map(\.language), ["English", "German"])
        XCTAssertEqual(all[1].greet(name: "Welt"), "Hallo, Welt!")
        // Default implementation from the Kotlin interface
        XCTAssertEqual(all[0].greetAll(names: ["A", "B"]), ["Hello, A!", "Hello, B!"])
    }

    func testSwiftImplementationsOfKotlinInterfaces() {
        let all: [any Greeting] = greetings() + [SwiftGreeting()]
        XCTAssertEqual(greetEveryone(greetings: all, name: "Kodee"), ["Hello, Kodee!", "Hallo, Kodee!", "Hello from Swift, Kodee!"])
        // The Kotlin default implementation of greetAll calls the Swift greet
        XCTAssertEqual(SwiftGreeting().greetAll(names: ["A"]), ["Hello from Swift, A!"])
    }

    func testFunctionalInterfaces() {
        XCTAssertEqual(validateAll(validator: notEmptyValidator(), inputs: ["", "x"]), [false, true])
        // A Swift closure becomes an implementation of the Kotlin fun interface
        let shortInput = validator { $0.count < 3 }
        XCTAssertTrue(shortInput.validate(input: "ok"))
        XCTAssertFalse(shortInput.validate(input: "too long"))
    }
}

// MARK: - Enums & sealed types

final class SealedAndEnumTests: XCTestCase {

    func testSealedClassesSupportExhaustiveSwitch() {
        let descriptions = loadingStates().map { state -> String in
            switch state.sealedType() {
            case .loading: "loading"
            case .success(let success): "success: \(success.value.data)"
            case .error(let error): "error: \(error.value.message)"
            }
        }
        XCTAssertEqual(descriptions, ["loading", "success: Kotlin ❤️ Swift", "error: Network is unavailable"])
    }

    func testSealedInterfaces() {
        XCTAssertEqual(execute(command: Command.Move(steps: 3)), "Moving 3 steps")
        XCTAssertEqual(execute(command: Command.Stop.shared), "Stopped")
    }

    func testEnumsAreSwiftEnums() {
        let planet = homePlanet()
        XCTAssertEqual(planet, .Earth)
        XCTAssertEqual(Planet.allCases.count, 3)
        XCTAssertEqual(planet.next(), .Jupiter)
        XCTAssertEqual(planet.rawValue, 1)
        XCTAssertEqual(Planet("Mercury"), .Mercury)
        XCTAssertEqual(planet.surfaceGravity, 9.8, accuracy: 0.1)
        XCTAssertEqual(Direction.North.opposite, .South)
    }
}

// MARK: - Generics & collections

final class GenericsTests: XCTestCase {

    func testGenericsAreErased() {
        let box = boxOf(value: "text")
        XCTAssertEqual(box.value as? String, "text")
        let mapped = box.map { Int32(($0 as! String).count) }
        XCTAssertEqual(mapped.value as? Int32, 4)
        XCTAssertNil(firstOrNull(items: []))
    }

    func testGenericFunctionsAcceptSwiftValues() {
        XCTAssertEqual(TypeChecker.shared.checkType(input: "str"), .IsString)
        XCTAssertEqual(TypeChecker.shared.checkType(input: Int32(1)), .IsInt)
        XCTAssertEqual(TypeChecker.shared.checkType(input: [1, 2, 3]), .IsList)
    }
}

final class CollectionsTests: XCTestCase {

    func testCollectionsAreSwiftCollections() {
        XCTAssertEqual(fibonacci(count: 7), [0, 1, 1, 2, 3, 5, 8])
        XCTAssertEqual(uniqueWords(text: "Swift Kotlin swift"), ["swift", "kotlin"])
        XCTAssertEqual(wordLengths(words: ["Kotlin", "Swift"]), ["Kotlin": 6, "Swift": 5])
        XCTAssertEqual(nestedLists(), [[1, 2], nil, [3]])
    }

    func testStdlibTypes() {
        // Arrays and other stdlib classes are Kotlin types from the KotlinStdlib module
        let bytes = bytesOf(text: "Kotlin")
        XCTAssertEqual(bytes.size, 6)
        XCTAssertEqual(bytes[0], 75)
        XCTAssertEqual(checksum(bytes: bytes), 625)
        let builder = ExportedKotlinPackages.kotlin.text.StringBuilder()
        XCTAssertEqual(buildGreeting(builder: builder, name: "Swift"), "Hello, Swift")
    }

    func testRanges() {
        XCTAssertEqual(digits(), 0...9)
        XCTAssertTrue(isAdult(age: 18))
    }
}

// MARK: - Operators & extensions

final class OperatorsTests: XCTestCase {

    func testArithmeticAndComparison() {
        let a = Vector(x: 1, y: 2)
        let b = Vector(x: 3, y: 4)
        XCTAssertEqual((a + b).x, 4)
        XCTAssertEqual((b - a).y, 2)
        XCTAssertEqual((a * 2).y, 4)
        XCTAssertEqual((-a).x, -1)
        XCTAssertTrue(a < b)
    }

    func testSubscriptsAndContains() {
        let grid = Grid(width: 2, height: 2)
        grid[3] = 7
        XCTAssertEqual(grid[3], 7)
        XCTAssertTrue(grid.contains(value: 7))
    }

    func testInvokeAndInfix() {
        let triple = Multiplier(factor: 3)
        XCTAssertEqual(triple(value: 5), 15)
        XCTAssertEqual(Int32(2).power(exponent: 10), 1024)
    }
}

final class ExtensionsTests: XCTestCase {

    func testExtensionsOnSwiftTypes() {
        XCTAssertEqual("hello".shout(), "HELLO!")
        XCTAssertEqual("ab".repeated(times: 3), "ababab")
        XCTAssertEqual("Kotlin and Swift".wordCount, 3)
        XCTAssertTrue(Int32(4).isEven())
        let missing: String? = nil
        XCTAssertEqual(missing.orDefault(), "default")
    }
}

// MARK: - Functions

final class FunctionTypesTests: XCTestCase {

    func testClosures() {
        XCTAssertEqual(applyTwice(value: 3) { $0 * $0 }, 81)
        XCTAssertEqual(makeMultiplier(factor: 4)(5), 20)
        XCTAssertEqual(transformAll(items: ["a", "b"]) { $0.uppercased() }, ["A", "B"])
    }

    func testSwiftImplementationOfKotlinDependency() {
        let platform = Platform(md5hasher: { "hash of \($0)" })
        XCTAssertEqual(reverseImportExample(platform: platform), "hash of example")
    }
}

final class AnnotationsTests: XCTestCase {

    func testOptInRequirementsAreSpi() {
        XCTAssertEqual(experimentalGreeting(), "Hello from an experimental API")
    }

    func testDocumentedDeclarations() {
        // KDoc is available in Xcode quick help for `documented(name:)`
        XCTAssertEqual(documented(name: "Swift"), "Hello, Swift")
    }
}

final class ExceptionsTests: XCTestCase {

    func testThrowingFunctions() throws {
        XCTAssertEqual(try parseAge(input: "42"), 42)
        // Kotlin exceptions are Swift errors
        XCTAssertThrowsError(try parseAge(input: "-1")) { error in
            XCTAssertEqual((error as? ValidationException)?.message, "Age cannot be negative")
        }
    }

    func testThrowingConstructors() {
        XCTAssertThrowsError(try PositiveNumber(value: -1))
    }
}

// MARK: - Coroutines

/// Swift subclass that overrides a Kotlin suspend function with an async method
final class CachedRepository: Repository {
    override func fetch(id: Int32) async throws -> String {
        try await Task.sleep(for: .milliseconds(1))
        return "Swift item \(id)"
    }
}

final class CoroutinesTests: XCTestCase {

    func testSuspendFunctionsAreAsync() async throws {
        let users = try await UsersViewModel().loadUsers()
        XCTAssertEqual(users.map(\.name), ["John Doe", "Jane Doe"])
    }

    func testFlowsAreAsyncSequences() async throws {
        var names: [String] = []
        for try await user in UsersViewModel().users.asAsyncSequence() {
            names.append(user.name)
        }
        XCTAssertEqual(names, ["John Doe", "Jane Doe"])
    }

    func testStateFlowValue() {
        let viewModel = UsersViewModel()
        XCTAssertNil(viewModel.selected.value)
        viewModel.select(user: User(name: "Jane", age: 25))
        XCTAssertEqual(viewModel.selected.value?.name, "Jane")
    }

    func testMutableStateFlowValue() {
        let viewModel = UsersViewModel()
        viewModel.query.value = "Jane"
        XCTAssertEqual(viewModel.query.value, "Jane")
    }

    func testSharedFlows() async throws {
        let viewModel = UsersViewModel()
        viewModel.select(user: User(name: "Jane", age: 25))
        viewModel.select(user: User(name: "John", age: 30))
        var events: [String] = []
        // A SharedFlow never completes, so stop collecting explicitly
        for try await event in viewModel.events.asAsyncSequence() {
            events.append(event)
            if events.count == 2 { break }
        }
        XCTAssertEqual(events, ["Selected Jane", "Selected John"])
    }

    func testSwiftOverridesOfSuspendFunctions() async throws {
        let kotlinItems = try await fetchAll(repository: Repository(), ids: [1])
        XCTAssertEqual(kotlinItems, ["Kotlin item 1"])
        let swiftItems = try await fetchAll(repository: CachedRepository(), ids: [1, 2])
        XCTAssertEqual(swiftItems, ["Swift item 1", "Swift item 2"])
    }

    func testSuspendFunctionTypes() async throws {
        let result = try await UsersViewModel().withLoading {
            try await Task.sleep(for: .milliseconds(10))
            return "from Swift"
        }
        XCTAssertEqual(result, "Loaded: from Swift")
    }

    func testCancellationIsPropagatedToKotlin() async throws {
        let cancelled = expectation(description: "Kotlin coroutine is cancelled")
        let task = Task {
            try await waitForever { cancelled.fulfill() }
        }
        try await Task.sleep(for: .milliseconds(100))
        task.cancel()
        do {
            try await task.value
            XCTFail("Expected CancellationError")
        } catch {
            XCTAssertTrue(error is CancellationError)
        }
        await fulfillment(of: [cancelled], timeout: 1)
    }
}

// MARK: - Hiding a dependency (Koin)

final class HiddenDependencyTests: XCTestCase {

    func testWrapperApiHidesKoin() {
        // AppGraph.greetingService() resolves through Koin on the Kotlin side
        XCTAssertEqual(AppGraph.shared.greetingService().welcome(name: "Swift"), "Welcome, Swift! (resolved by Koin)")
    }

    func testKoinTypesAreEmptyStubs() {
        // HIDDEN keeps the leaked types visible, but only as empty stub classes.
        // AppGraph.koin and AppGraph.modules() still compile, but calling them traps
        let koin: AnyClass = ExportedKotlinPackages.org.koin.core.Koin.self
        let module: AnyClass = ExportedKotlinPackages.org.koin.core.module.Module.self
        XCTAssertTrue(koin is KotlinBase.Type)
        XCTAssertTrue(module is KotlinBase.Type)
    }
}

// MARK: - Implementing in Swift

// A Swift implementation of the Kotlin UserRepository interface: a Flow property
// and a suspend function, backed by a Kotlin MutableStateFlow from mutableStateFlow(initial:)
final class SwiftUserRepository: KotlinBase, UserRepository {
    private let user = mutableStateFlow(initial: "")

    var signedInUser: any KotlinTypedFlow<String> { user }

    func signInUser(user: String) async throws {
        self.user.value = user
    }
}

final class SwiftImplementationTests: XCTestCase {

    func testKotlinConsumesTheSwiftRepository() async throws {
        let repository = SwiftUserRepository()
        let viewModel = SignInViewModel(repository: repository)

        var greetings: [String] = []
        for try await greeting in viewModel.greeting.asAsyncSequence() {
            greetings.append(greeting)
            if greetings.count == 1 {
                try await viewModel.signIn(user: "Alice")
            }
            if greetings.count == 2 {
                break
            }
        }
        XCTAssertEqual(greetings, ["Nobody is signed in", "Hello, Alice!"])
    }

    func testSignInTrimsTheName() async throws {
        // The Kotlin InMemoryUserRepository, for comparison with the Swift one
        let viewModel = SignInViewModel(repository: InMemoryUserRepository())

        var greetings: [String] = []
        for try await greeting in viewModel.greeting.asAsyncSequence() {
            greetings.append(greeting)
            if greetings.count == 1 {
                try await viewModel.signIn(user: "  Bob ")
            }
            if greetings.count == 2 {
                break
            }
        }
        XCTAssertEqual(greetings, ["Nobody is signed in", "Hello, Bob!"])
    }
}

// MARK: - Generic wrappers

final class GenericWrappersTests: XCTestCase {

    func testGenericStatePayloadsAreErased() async throws {
        var states: [ScreenState] = []
        for try await state in ProfileLoader().load(succeed: true).asAsyncSequence() {
            states.append(state)
        }
        XCTAssertEqual(states.count, 2)
        guard case .ready(let ready) = states[1].sealedType() else {
            XCTFail("expected Ready with a Profile payload")
            return
        }
        // Ready<T>.data is (any _KotlinBridgeable)?, so Swift casts it back
        XCTAssertEqual((ready.value.data as? Profile)?.name, "Kodee")
        XCTAssertEqual((ready.value.data as? Profile)?.followers, 2025)
    }

    func testWrapperPayloadsAreTyped() async throws {
        let model = ProfileScreenModel(loader: ProfileLoader())

        var states: [ProfileState] = []
        for try await state in model.load(succeed: false).asAsyncSequence() {
            states.append(state)
        }
        XCTAssertEqual(states.count, 2)
        guard case .error(let error) = states[1].sealedType() else {
            XCTFail("expected Error")
            return
        }
        XCTAssertEqual(error.value.message, "No connection")
        // Ready carries a typed Profile, and headline(state:) is exported
        // because ProfileState is not generic
        XCTAssertEqual(model.headline(state: states[0]), "Loading…")
        XCTAssertEqual(model.headline(state: states[1]), "No connection")
    }
}

// MARK: - Features added to the topic files

// A Swift implementation of the Kotlin Translator interface, conforming to KotlinBase directly
final class ShoutingTranslator: KotlinBase, Translator {
    var language: String { "Shouting" }

    func translate(word: String) -> String {
        word.uppercased()
    }
}

final class TranslatorTests: XCTestCase {

    func testKotlinTranslator() {
        let translator = defaultTranslator()
        XCTAssertEqual(translator.language, "Pig Latin")
        XCTAssertEqual(translator.translate(word: "hello"), "ellohay")
        // The default implementation maps over translate(word:)
        XCTAssertEqual(translator.translateAll(words: ["a", "b"]), ["aay", "bay"])
        XCTAssertEqual(translateSentence(sentence: "swift export", translator: translator), "[Pig Latin] wiftsay xporteay")
    }

    func testSwiftTranslatorPassedToKotlin() {
        XCTAssertEqual(translateSentence(sentence: "swift export", translator: ShoutingTranslator()), "[Shouting] SWIFT EXPORT")
        // Kotlin's default translateAll(words:) calls the Swift translate(word:)
        XCTAssertEqual(ShoutingTranslator().translateAll(words: ["a", "b"]), ["A", "B"])
    }
}

final class BasicsAdditionsTests: XCTestCase {

    func testObjCNameRenamesTopLevelFunctions() {
        // Kotlin makeLoud(text:), exported as shout(text:)
        XCTAssertEqual(shout(text: "kotlin"), "KOTLIN")
    }

    func testFormatPriceOverloadForTheDefaultValue() {
        XCTAssertEqual(formatPrice(amount: 9.99), "9.99 EUR")
    }
}

final class ClassesAdditionsTests: XCTestCase {

    func testCompanionObjectProperties() {
        XCTAssertEqual(Temperature.Companion.shared.freezing.celsius, 0)
        XCTAssertEqual(Temperature.Companion.shared.freezing.fahrenheit, 32)
    }

    func testInnerClassMutatesTheOuterInstance() {
        let counter = StepCounter()
        let step = StepCounter.Step(by: 5, outer__: counter)
        XCTAssertEqual(step.apply(), 5)
        XCTAssertEqual(step.by, 5)
        // The inner instance mutated the outer counter
        XCTAssertEqual(counter.value, 5)
        XCTAssertEqual(step.apply(), 10)
    }

    func testObjectCallsTheExpectDeclaration() {
        XCTAssertTrue(AppInfo.shared.banner().hasPrefix("Swift Export sample on "))
    }
}

final class GenericsAdditionsTests: XCTestCase {

    func testDescribeShowsTheErasedValue() {
        XCTAssertEqual(Box(value: Int32(3)).describe(), "Box(3)")
        XCTAssertEqual(boxOf(value: "text").describe(), "Box(text)")
    }
}

final class CollectionsAdditionsTests: XCTestCase {

    func testEvensInFiltersEvenNumbers() {
        XCTAssertEqual(evensIn(range: 1...10), [2, 4, 6, 8, 10])
    }
}

final class ExceptionsAdditionsTests: XCTestCase {

    func testWalletThrowsWithAPayload() throws {
        let wallet = try Wallet(balance: 10)
        try wallet.pay(amount: 4)
        XCTAssertEqual(wallet.balance, 6)

        var caught: InsufficientFundsException?
        do {
            try wallet.pay(amount: 25)
        } catch let error as InsufficientFundsException {
            caught = error
        }
        XCTAssertEqual(caught?.missing, 19)
        // The failed payment did not change the balance
        XCTAssertEqual(wallet.balance, 6)
        XCTAssertThrowsError(try Wallet(balance: -1))
    }
}

final class CoroutinesAdditionsTests: XCTestCase {

    func testCountdownFinishes() async throws {
        let countdown = Countdown()
        let result = try await countdown.run(from: 1)
        XCTAssertEqual(result, 1)
        XCTAssertFalse(countdown.wasCancelled)
    }

    func testCountdownSeesCancellation() async throws {
        let countdown = Countdown()
        let task = Task { try await countdown.run(from: 30) }
        try await Task.sleep(for: .milliseconds(200))
        task.cancel()
        do {
            try await task.value
            XCTFail("Expected CancellationError")
        } catch {
            XCTAssertTrue(error is CancellationError)
        }
        // The Kotlin object saw the cancellation and kept the flag for Swift
        XCTAssertTrue(countdown.wasCancelled)
    }
}

final class PlatformAdditionsTests: XCTestCase {

    func testExpectActualCollapsesToOneFunction() {
        #if os(macOS)
        XCTAssertTrue(osName().hasPrefix("Version"))
        #elseif os(iOS)
        XCTAssertEqual(osName(), "iOS")
        #endif
    }
}
