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

struct ClassesSection: View {
    var body: some View {
        Section("Classes") {
            let myClass = MyClass(property: 5)
            Row("Typealias & nested class", "sum = \(sum(a: myClass, b: MyNested(nestedProperty: 6)))")
            Row("Inner class", "outer property = \(MyClass.Inner(outer__: myClass).outerProperty())")
            // Kotlin computes the area of shapes implemented both in Kotlin and in Swift
            Row("Inheritance", String(format: "total area = %.2f", totalArea(shapes: [Square(side: 2), SwiftCircle(radius: 1)])))
            Row("Object", "Counter.shared.increment() = \(Counter.shared.increment())")
            Row("Companion object", "100 °C = \(Temperature.Companion.shared.fromCelsius(value: 100).fahrenheit) °F")
            let point = Point(x: 1, y: 2)
            Row("Data class", "\(point.copy(x: 3, y: 4)), equal: \(point == Point(x: 1, y: 2))")
            Row("Value class", "domain = \(email(value: "kotlin@jetbrains.com").domain)")
            Row("@ObjCName", "SwiftFriendlyName().run(21) = \(SwiftFriendlyName().run(21))")
            Row("Interface", greetings().map { $0.greet(name: "Swift") }.joined(separator: " "))
        }
    }
}

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

struct EnumsAndSealedSection: View {
    var body: some View {
        Section("Enums & sealed types") {
            let planet = homePlanet()
            // Kotlin enums are native Swift enums
            switch planet {
            case .Earth: Row("Enum", String(format: "Earth gravity = %.2f m/s²", planet.surfaceGravity))
            default: Row("Enum", "Not at home: \(planet)")
            }
            Row("CaseIterable", Planet.allCases.map(\.description).joined(separator: ", "))
            // Sealed hierarchies support exhaustive switches via `sealedType()`
            ForEach(Array(loadingStates().enumerated()), id: \.offset) { _, state in
                switch state.sealedType() {
                case .loading: Row("Sealed class", "Loading…")
                case .success(let success): Row("Sealed class", "Success: \(success.value.data)")
                case .error(let error): Row("Sealed class", "Error: \(error.value.message)")
                }
            }
        }
    }
}

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

struct CoroutinesSection: View {
    private let viewModel = UsersViewModel()
    @State private var users: [User]? = nil
    @State private var showFlow = false

    var body: some View {
        Section("Coroutines") {
            // Suspend functions are async Swift functions
            Row("Suspend function", users.map { $0.map(\.name).joined(separator: ", ") } ?? "Loading…")
                .task {
                    users = try? await viewModel.loadUsers()
                }
            // Flows are async sequences
            Button("Collect Flow") {
                showFlow = true
            }
            .sheet(isPresented: $showFlow) {
                UsersFlowView(viewModel: viewModel)
            }
        }
    }
}

struct UsersFlowView: View {
    let viewModel: UsersViewModel
    @State private var items: [User] = []

    var body: some View {
        NavigationStack {
            List(items) { user in
                Text("\(user.name), aged \(user.age)")
            }
            .navigationTitle("Users")
            .task {
                items.removeAll()
                do {
                    // No casts are needed, the flow elements are typed as User
                    for try await user in viewModel.users.asAsyncSequence() {
                        items.append(user)
                    }
                } catch {
                    print("Flow collection was cancelled: \(error)")
                }
            }
        }
    }
}

struct PlatformSection: View {
    var body: some View {
        Section("Platform") {
            // Declared in iosMain, and only available on iOS
            Row("iosMain", platformName())
            Row("UIKit type", currentDevice().model)
        }
    }
}

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
    }
}

extension Shared.User: @retroactive Identifiable {}

#Preview {
    ContentView()
}
