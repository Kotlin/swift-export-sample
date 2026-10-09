[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

# Kotlin Swift Export Sample

This project demonstrates what Kotlin Swift Export can do. The iOS app is a catalog of Swift Export features: every screen calls Kotlin code from Swift and shows the Swift expression next to its result. The Gradle setup shows the Swift Export DSL introduced in Kotlin 2.5.0, with three Kotlin modules (`:shared`, `:module-a`, `:module-b`) exported as separate Swift modules and one dependency (Koin) hidden from the export.

## ⚠️ Experimental feature notice

**Swift Export is an experimental feature and subject to change in any future releases.** It may not function as expected, and you may encounter bugs. This project is an early technology demonstration and is **not production-ready**. Use it at your own risk.

## Feature catalog

The app opens on a list of features. Every feature has a Kotlin file in `shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/` and a screen in `iosApp/iosApp/Features/` with the same name. The Kotlin file starts with a short comment describing what the construct becomes in Swift.

| Section | Feature | Kotlin | Swift screen | What it shows |
|---|---|---|---|---|
| Basics | Classes | `Classes.kt` | `ClassesView.swift` | Final classes, nested and inner classes (`outer__:`), typealiases, `object` → `.shared`, companion → `.Companion.shared`, private constructors |
| | Functions | `Functions.kt` | `FunctionsView.swift` | Top-level functions, overloads, `vararg` → variadic, `@ObjCName(swiftName:)`, missing default arguments and the overload workaround |
| | Extensions | `Extensions.kt` | `ExtensionsView.swift` | Extension functions and properties → Swift extensions |
| | Operators | `Operators.kt` | `OperatorsView.swift` | `+`, `*`, `<` from `compareTo`, subscripts from `get`, `~=` from `contains` |
| | Annotations & docs | `Annotations.kt` | `AnnotationsView.swift` | KDoc → Swift documentation, `@Deprecated` → `@available`, `@HiddenFromObjC` |
| Type hierarchy | Interfaces | `Interfaces.kt` | `InterfacesView.swift` | Protocols, default methods, a Swift class implementing a Kotlin interface, `fun interface` |
| | Inheritance | `Inheritance.kt` | `InheritanceView.swift` | Open and abstract classes, Swift subclasses whose overrides are called from Kotlin |
| | Enums | `Enums.kt` | `EnumsView.swift` | Native Swift enums, exhaustive `switch`, `allCases`, `rawValue`, `init?(_:)` |
| | Sealed classes | `Sealed.kt` | `SealedView.swift` | `sealedType()` → exhaustive `switch`, nested subclasses, `object` subclasses |
| | Data & value classes | `DataClasses.kt` | `DataClassesView.swift` | `copy`, `==`, `Hashable`, `description`, value class wrappers |
| Types | Types & nullability | `Types.kt` | `TypesView.swift` | `Int32`/`Int64`, unsigned types, `Char` → `UInt16`, optionals, `Unit` → `Void`, `Nothing` → `Never` |
| | Collections | `Collections.kt` | `CollectionsView.swift` | `List`/`Set`/`Map` → Swift collections, `IntRange` → `ClosedRange` |
| | Generics | `Generics.kt` | `GenericsView.swift` | Erased type parameters, Swift values passed as `Any`, generic classes, the integer-literal pitfall |
| | Closures | `Closures.kt` | `ClosuresView.swift` | Function types ↔ Swift closures, passing a Swift-only API (CryptoKit) to Kotlin |
| | Exceptions | `Exceptions.kt` | `ExceptionsView.swift` | `@Throws` → `throws`, catching Kotlin exceptions by type |
| Concurrency | Coroutines | `Coroutines.kt` | `CoroutinesView.swift` | `suspend` → `async throws`, suspend lambdas, cancelling a Swift `Task` cancels the coroutine |
| | Flows | `Flows.kt` | `FlowsView.swift` | `Flow<T>` → typed `AsyncSequence`, `StateFlow.value`, setting a `MutableStateFlow` from Swift |
| Modules | Modules | `Modules.kt`, `:module-a`, `:module-b` | `ModulesView.swift` | One Swift module per exported Kotlin module, library vs. consumer configuration |
| | Platform code | `Platform.kt`, `Platform.ios.kt` | `PlatformView.swift` | `iosMain` code and `expect`/`actual` |
| | Hiding a dependency | `HiddenDependency.kt` | `HiddenDependencyView.swift` | Koin leaked into the public API and hidden with `SwiftExportVisibility.HIDDEN` |

The catalog itself is `iosApp/iosApp/Catalog/FeatureCatalog.swift`; `DemoComponents.swift` next to it holds the shared row and screen views.

## Project structure

- `:shared` - The umbrella module. It is exported as the `Shared` Swift module and is the only module wired into Xcode. It depends on `:module-a` and `:module-b` via `api`, so both end up as separate Swift modules. It uses `kotlinx-coroutines` and Koin as `implementation` dependencies.
- `:module-a` - A Kotlin library that describes its own Swift representation (`ModuleA`) in its build script. This is what a library author would do.
- `:module-b` - A Kotlin library with no Swift Export configuration at all. `:shared` decides how it appears in Swift (`ModuleB`). This is what a consumer does when a library says nothing about itself.
- `iosApp` - The SwiftUI app. Its Run Script build phase calls `./gradlew :shared:embedSwiftExportForXcode`.

## Swift Export configuration

Swift Export is configured in `build.gradle.kts` through the `export.swift {}` block inside the `kotlin {}` extension. The legacy `swiftExport {}` block is deprecated in Kotlin 2.5.0 and reports a diagnostic pointing to the new DSL.

### Umbrella module (`:shared`)

```kotlin
kotlin {
    iosArm64()
    iosSimulatorArm64()

    export {
        @OptIn(ExperimentalSwiftExportDsl::class)
        swift {
            // Root module name
            moduleName = "Shared"
            // Collapse rule
            rootPackage = "com.github.jetbrains.swiftexport"

            // Register :embedSwiftExportForXcode task
            xcodeIntegration {
                // Explicitly reconfigure exported module
                configure(projects.moduleB) {
                    // Exported module name
                    moduleName = "ModuleB"
                    // Collapse exported dependency rule
                    rootPackage = "com.github.jetbrains.moduleb"
                }
                // Keep Koin out of the Swift API: only empty stubs are generated for its types
                configure(libs.koin.core, SwiftExportVisibility.HIDDEN)
            }
        }
    }

    sourceSets.commonMain.dependencies {
        implementation(libs.kotlinx.coroutines.core)
        implementation(libs.koin.core)
        api(projects.moduleA)
        api(projects.moduleB)
    }
}
```

### Library module (`:module-a`)

```kotlin
kotlin {
    iosArm64()
    iosSimulatorArm64()

    export {
        @OptIn(ExperimentalSwiftExportDsl::class)
        swift {
            // Exported module name
            moduleName = "ModuleA"
            // Collapse exported dependency rule
            rootPackage = "com.github.jetbrains.modulea"
        }
    }
}
```

`:module-b` has no Swift Export configuration at all. Its module name and root package come from the `configure(projects.moduleB) { ... }` override in `:shared`.

## How the new DSL works

Everything starts with `export.swift {}`. It replaces the old `swiftExport {}` block and takes two properties for the current module: `moduleName` and `rootPackage`. Configuring it does not register any tasks on its own.

`rootPackage` is the old `flattenPackage` under a new name. Kotlin code normally lives in packages such as `com.github.jetbrains.modulea`. With `rootPackage` set, that prefix is dropped and the classes can be used from Swift directly.

The biggest change is that there is no `export(...)` list anymore. What gets exported follows from the dependency graph. Direct `api` dependencies of the umbrella module become their own Swift modules. Everything else, including `implementation` dependencies and transitive ones, stays available to the exported API but is not exposed as a separate module.

A library configures its Swift representation once, the way `:module-a` does. The Kotlin Gradle plugin publishes that configuration as metadata next to the library, and consumers pick it up automatically. This works for project dependencies and for published external dependencies, so a consumer no longer repeats `moduleName` and `rootPackage` for every library it exports.

`xcodeIntegration {}` opts a module into Xcode and registers the `embedSwiftExportForXcode` task. Only `:shared` calls it. Inside the block, `settings.put(...)` passes extra settings to the export pipeline, and `configure(dependency) { ... }` reconfigures any exported dependency, whether it is a project, a Maven coordinate, or a version catalog entry. A consumer override wins over the library's published metadata, which in turn wins over the derived default. `:shared` uses this to name `:module-b`, since that library has no metadata of its own.

The same `configure` block also accepts a `visibility`. `SwiftExportVisibility.EXPOSED` forces a dependency to be fully exported even if it is not an `api` dependency, and `SwiftExportVisibility.HIDDEN` does the opposite. There is a shorthand, `configure(dependency, SwiftExportVisibility.HIDDEN)`. `:shared` uses it to hide Koin; see [Hiding a dependency](#hiding-a-dependency-koin).

### Migrating from the legacy DSL

| Legacy `swiftExport {}` | New `export.swift {}` |
|---|---|
| `swiftExport { ... }` | `export { swift { ... } }` |
| `flattenPackage = "..."` | `rootPackage = "..."` |
| `export(project(":module-a")) { ... }` | Declare `api(projects.moduleA)`; the library configures itself, or the consumer overrides it via `xcodeIntegration { configure(projects.moduleA) { ... } }` |
| `embedSwiftExportForXcode` registered implicitly | Registered only when `xcodeIntegration()` is called |

## Hiding a dependency (Koin)

`:shared` uses Koin internally, but `HiddenDependency.kt` leaks it into the public API on purpose:

```kotlin
object AppGraph {
    // Accidental leaks: public declarations that mention Koin types.
    val koin: Koin by lazy { startKoin { modules(appModule) }.koin }
    fun modules(): List<Module> = listOf(appModule)

    // Swift-facing API: Koin stays an implementation detail.
    fun greetingService(): GreetingService = koin.get()
}
```

Koin is an `implementation` dependency, but Swift Export follows every type that appears in the exported API. Without any configuration, Koin is exported transitively as the `IoInsertKoinKoinCore` Swift module: about 1,800 lines of generated Swift with 40 types, plus a `KotlinStdlib` module with about 1,700 lines.

`configure(libs.koin.core, SwiftExportVisibility.HIDDEN)` stops that:

- Koin's types become empty stub classes (`Koin`, `Module`) with no members. `IoInsertKoinKoinCore.swift` shrinks to 23 lines, and `KotlinStdlib.swift` to about 240.
- The leaked declarations still compile in Swift, but their bodies are `fatalError()`. The "Call AppGraph.shared.koin" button on the screen shows the crash.
- Declarations that don't mention Koin, such as `greetingService()`, work normally.

HIDDEN is also the way out when a dependency's generated code doesn't compile. Hide the dependency, then make sure no Swift-facing declaration mentions its types.

## Not supported or different from Objective-C export

These are visible in the sample as workarounds, or not shown at all:

- Default argument values are not exported. Swift passes every argument; add Kotlin overloads for common cases (`formatPrice` in `Functions.kt`).
- Generics are erased, so values of type parameters must be cast in Swift. A bare Swift integer literal passed as `Any` arrives in Kotlin as `Double`; use `Int32(7)`.
- `protected` members, `inline` functions with `reified` type parameters, and companion blocks/static extensions are not exported.
- Mutable collections are not converted to Swift collections; keep read-only `List`, `Set` and `Map` in Swift-facing signatures.
- Abstract members that a Swift subclass doesn't override compile, but trap at runtime.
- An exception thrown from a function without `@Throws` terminates the app.
- Names that clash with Swift or SwiftUI types are a practical issue: a Kotlin `Shape` or `Hasher` is ambiguous in a SwiftUI file, so this sample uses `Figure` and `TextHasher`.

## Getting started

### Requirements

- Kotlin `2.5.20-dev-15` from the JetBrains experimental repository (`https://packages.jetbrains.team/maven/p/kt/experimental`, configured in `settings.gradle.kts`). It is the 2.5.20 build closest to the 2.5.0 release.
- Xcode 16 or newer (the project uses synchronized folders). Tested with Xcode 27.0.
- iOS 18 deployment target, which Swift Export's coroutine support requires.

### Running the project

1. Clone this repository.
2. Open `iosApp/iosApp.xcodeproj` in Xcode.
3. Pick an iPhone simulator on an Apple silicon Mac (the Gradle build declares `iosSimulatorArm64` and `iosArm64`) and run the `iosApp` scheme.

The Run Script build phase calls `./gradlew :shared:embedSwiftExportForXcode`. To read the generated Swift, open `shared/build/SwiftExport/iosSimulatorArm64/files/<Module>/<Module>.swift` after a build.

## Learn more

- [Interoperability with Swift using Swift export](https://kotlinlang.org/docs/native-swift-export.html)
- For more information on Kotlin Multiplatform, check out the [Kotlin Multiplatform Documentation](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html).
