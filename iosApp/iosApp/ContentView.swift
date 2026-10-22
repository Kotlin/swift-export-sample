import SwiftUI
import CryptoKit

import Shared
import ModuleA
import ModuleB
import ModuleC

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
            Button {
                counter = Counter.shared.increment()
            } label: {
                Row("Object", "Counter.shared.value = \(counter), tap to increment")
            }
            Row("Companion object", "100 °C = \(Temperature.Companion.shared.fromCelsius(value: 100).fahrenheit) °F")
            let point = Point(x: 1, y: 2)
            Row("Data class", "\(point.copy(x: 3, y: 4)), equal: \(point == Point(x: 1, y: 2))")
            Row("Value class", "domain = \(email(value: "kotlin@jetbrains.com").domain)")
            Row("@ObjCName", "SwiftFriendlyName().run(21) = \(SwiftFriendlyName().run(21))")
            Row("Interface", greetings().map { $0.greet(name: "Swift") }.joined(separator: " "))
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
    @State private var isShowingFlow = false

    var body: some View {
        Section("Coroutines") {
            // Suspend functions are async Swift functions
            Row("Suspend function", usersDescription)
            // Flows are async sequences
            Button("Collect Flow") {
                isShowingFlow = true
            }
        }
        .task {
            guard users == nil else { return }
            do {
                users = .success(try await viewModel.loadUsers())
            } catch {
                users = .failure(error)
            }
        }
        .sheet(isPresented: $isShowingFlow) {
            UsersFlowView(viewModel: viewModel)
        }
    }

    private var usersDescription: String {
        switch users {
        case nil: "Loading…"
        case .success(let users): users.map(\.name).joined(separator: ", ")
        case .failure(let error): "Failed: \(error)"
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
            // Declared in iosMain, and only available on iOS
            Row("iosMain", platformName())
            Row("UIKit type", currentDevice().model)
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
