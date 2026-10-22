import SwiftUI
import CryptoKit

@_spi(com$github$jetbrains$swiftexport$ExperimentalSampleApi) import Shared
import ModuleA
import ModuleB
import ModuleC
// Members inherited from stdlib classes, such as Throwable.message, live in KotlinStdlib
import KotlinStdlib

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ModulesSection()
                ClassesSection()
                TypesSection()
                EnumsAndSealedSection()
                FunctionsSection()
                CoroutinesSection()
                PlatformSection()
            }
            .navigationTitle(SAMPLE_NAME)
        }
    }
}

// MARK: - Modules

/// Every exported Kotlin module is a separate Swift module
struct ModulesSection: View {
    var body: some View {
        Section("Modules") {
            // :module-a configures its Swift module itself
            Row("ModuleA", useClassFromA().hello())
            // :module-b is configured by the :shared consumer
            Row("ModuleB", useClassFromB().hello())
            // :module-c is an implementation dependency exposed via SwiftExportVisibility.EXPOSED
            Row("ModuleC", "moduleCFunction() = \(moduleCFunction())")
            // Declarations outside of `rootPackage` keep their package namespace
            Row("Nested package", nested.NestedPackageClass().hello())
        }
    }
}

// MARK: - Classes

struct ClassesSection: View {
    // Kotlin objects are not observable, so the view keeps its own copy of the counter
    @State private var counter = Counter.shared.value

    var body: some View {
        Section("Classes") {
            let myClass = MyClass(property: 5)
            Row("Typealias & nested class", "sum = \(sum(a: myClass, b: MyNested(nestedProperty: 6)))")
            Row("Inner class", "outer property = \(MyClass.Inner(outer__: myClass).outerProperty())")
            // Kotlin computes the area of shapes implemented both in Kotlin and in Swift
            let area = totalArea(shapes: [Square(side: 2), SwiftCircle(radius: 1)])
            Row("Inheritance", "total area = \(area.formatted(.number.precision(.fractionLength(2))))")
            Row("Swift overrides & super", formatWith(formatter: LoudFormatter(), message: "hello"))
            Button {
                counter = Counter.shared.increment()
            } label: {
                Row("Object", "Counter.shared.value = \(counter), tap to increment")
            }
            .buttonStyle(.borderless)
            Row("Companion object", "100 °C = \(Temperature.Companion.shared.fromCelsius(value: 100).fahrenheit) °F")
            let point = Point(x: 1, y: 2)
            Row("Data class", "\(point.copy(x: 3, y: 4)), equal: \(point == Point(x: 1, y: 2))")
            Row("Value class", "domain = \(email(value: "kotlin@jetbrains.com").domain)")
            Row("@ObjCName", "SwiftFriendlyName().run(21) = \(SwiftFriendlyName().run(21))")
            Row("Interface", greetEveryone(greetings: greetings() + [FrenchGreeting()], name: "Swift").joined(separator: " "))
            // :module-d is HIDDEN, so its Engine class is an empty stub in Swift
            Row("Hidden module", Car().drive())
        }
    }
}

/// Swift subclass of an open Kotlin class.
/// `Shared.Shape` is module-qualified, because SwiftUI declares its own `Shape`
final class SwiftCircle: Shared.Shape {
    let radius: Double

    init(radius: Double) {
        self.radius = radius
        super.init(name: "Circle")
    }

    override func area() -> Double {
        Double.pi * radius * radius
    }
}

/// Swift subclass that overrides an open Kotlin property and method, and calls `super`
final class LoudFormatter: MessageFormatter {
    override var prefix: String { "Swift" }

    override func format(message: String) -> String {
        super.format(message: message).uppercased()
    }
}

/// Swift implementation of a Kotlin interface.
/// It inherits from an exported Kotlin class, because KotlinBase itself can't be instantiated
final class FrenchGreeting: GreetingBase, Greeting {
    var language: String { "French" }

    func greet(name: String) -> String { "Bonjour, \(name)!" }
}

// MARK: - Types

struct TypesSection: View {
    var body: some View {
        Section("Types") {
            Row("Nullability", greet(name: nil))
            Row("Unsigned", "unsigned(21) = \(unsigned(value: 21))")
            Row("List", "\(fibonacci(count: 8))")
            Row("Set", "\(uniqueWords(text: "kotlin swift Kotlin").sorted())")
            Row("Map", "\(wordLengths(words: ["Kotlin", "Swift"]))")
            Row("Range", "\(digits())")
            Row("Any", "String is \(TypeChecker.shared.checkType(input: "str")), array is \(TypeChecker.shared.checkType(input: [1, 2, 3]))")
            Row("Generics", "boxOf(\"text\").value = \(boxOf(value: "text").value as? String ?? "")")
            let vector = Vector(x: 1, y: 2) + Vector(x: 3, y: 4)
            Row("Operators", "\(vector * 2), -v = \(-vector)")
            Row("Extensions", "\"hello\".shout() = \("hello".shout())")
        }
    }
}

// MARK: - Enums & sealed types

struct EnumsAndSealedSection: View {
    // Stored once, so every state keeps a stable identity across body updates
    @State private var states = loadingStates()

    var body: some View {
        Section("Enums & sealed types") {
            let planet = homePlanet()
            // Kotlin enums are native Swift enums
            switch planet {
            case .Earth:
                Row("Enum", "Earth gravity = \(planet.surfaceGravity.formatted(.number.precision(.fractionLength(2)))) m/s²")
            default:
                Row("Enum", "Not at home: \(planet)")
            }
            Row("CaseIterable", Planet.allCases.map(\.description).joined(separator: ", "))
            // Sealed hierarchies support exhaustive switches via `sealedType()`
            ForEach(states, id: \.self) { state in
                Row("Sealed class", describe(state))
            }
        }
    }

    private func describe(_ state: LoadingState) -> String {
        switch state.sealedType() {
        case .loading: "Loading…"
        case .success(let success): "Success: \(success.value.data)"
        case .error(let error): "Error: \(error.value.message)"
        }
    }
}

// MARK: - Functions

struct FunctionsSection: View {
    var body: some View {
        Section("Functions") {
            Row("Vararg", "sumAll(1, 2, 3) = \(sumAll(numbers: 1, 2, 3))")
            Row("Closure", "applyTwice(3) { $0 * $0 } = \(applyTwice(value: 3) { $0 * $0 })")
            Row("Fun interface", "\(validateAll(validator: validator { !$0.isEmpty }, inputs: ["", "x"]))")
            // Kotlin can't call Swift-only APIs such as CryptoKit, so Swift passes the implementation as a closure
            let platform = Platform(md5hasher: { input in
                Insecure.MD5.hash(data: Data(input.utf8)).map { String(format: "%02x", $0) }.joined()
            })
            Row("Swift API from Kotlin", reverseImportExample(platform: platform))
            Row("@Throws", parseAgeResult("forty two"))
            // Context parameters are passed first, without a label
            Row("Context parameters", placeOrder(AuditLog(), item: "book"))
            // Opt-in requirements are SPI, see `@_spi` on the Shared import
            Row("@RequiresOptIn", experimentalGreeting())
        }
    }

    private func parseAgeResult(_ input: String) -> String {
        do {
            return "\(try parseAge(input: input))"
        } catch let error as ValidationException {
            return error.message ?? "unknown error"
        } catch {
            return "\(error)"
        }
    }
}

// MARK: - Coroutines

struct CoroutinesSection: View {
    @State private var viewModel = UsersViewModel()
    @State private var users: Result<[User], Error>?
    @State private var items: Result<[String], Error>?
    @State private var isShowingFlow = false

    var body: some View {
        Section("Coroutines") {
            // Suspend functions are async Swift functions
            Row("Suspend function", describe(users) { $0.map(\.name).joined(separator: ", ") })
            // Kotlin calls the async Swift override of a suspend function
            Row("Suspend override", describe(items) { $0.joined(separator: ", ") })
            // Flows are async sequences
            Button("Collect Flow") {
                isShowingFlow = true
            }
            .buttonStyle(.borderless)
        }
        .task {
            guard users == nil else { return }
            users = await Result(catching: { try await viewModel.loadUsers() })
            items = await Result(catching: { try await fetchAll(repository: SwiftRepository(), ids: [1, 2]) })
        }
        .sheet(isPresented: $isShowingFlow) {
            UsersFlowView(viewModel: viewModel)
        }
    }

    private func describe<T>(_ result: Result<T, Error>?, _ success: (T) -> String) -> String {
        switch result {
        case nil: "Loading…"
        case .success(let value): success(value)
        case .failure(let error): "Failed: \(error)"
        }
    }
}

/// Swift subclass that overrides a Kotlin suspend function with an async method
final class SwiftRepository: Repository {
    override func fetch(id: Int32) async throws -> String {
        "Swift item \(id)"
    }
}

private extension Result where Failure == Error {
    init(catching body: () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error)
        }
    }
}

struct UsersFlowView: View {
    let viewModel: UsersViewModel
    @State private var items: [User] = []
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.self) { user in
                    Text("\(user.name), aged \(user.age)")
                }
                if let error {
                    Text("Flow failed: \(error.localizedDescription)")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                await collectUsers()
            }
        }
    }

    private func collectUsers() async {
        items.removeAll()
        error = nil
        do {
            // No casts are needed, the flow elements are typed as User
            for try await user in viewModel.users.asAsyncSequence() {
                items.append(user)
            }
        } catch is CancellationError {
            // Dismissing the sheet cancels the task, which cancels the Kotlin flow
        } catch {
            self.error = error
        }
    }
}

// MARK: - Platform

struct PlatformSection: View {
    var body: some View {
        Section("Platform") {
            // Each platform gets the API from its own source set
            #if os(iOS)
            Row("iosMain", platformName())
            Row("UIKit type", currentDevice().model)
            #elseif os(macOS)
            Row("macosMain", platformName())
            #endif
        }
    }
}

// MARK: - Helpers

/// A titled value, read by VoiceOver as a single element
struct Row: View {
    let title: String
    let value: String

    init(_ title: String, _ value: String) {
        self.title = title
        self.value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
