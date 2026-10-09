[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

# Kotlin Swift export sample

This project shows how to export Kotlin Multiplatform code to Swift with Swift export. It uses the `export.swift {}` DSL and the Swift package export added in Kotlin 2.5.0, exports several Gradle modules, and shows what each Kotlin language feature looks like on the Swift side.

The Kotlin code has two consumers. An iOS and macOS app gets it through the Xcode integration, and a plain Swift package depends on the exported Swift package.

## Beta feature notice

Swift export is in [Beta](https://kotlinlang.org/docs/components-stability.html#stability-levels-explained) starting with Kotlin 2.5.0. You can use it, and we'll do our best to minimize migration issues, but it isn't finished yet, so changes are still possible. Watch for deprecation warnings when you update Kotlin, and report problems in [YouTrack](https://kotl.in/issue) or the [#swift-export](https://kotlinlang.slack.com/archives/C073GUW6WN9) channel on Kotlin Slack.

The Gradle DSL is still marked with `@ExperimentalSwiftExportDsl`. Without `@OptIn(ExperimentalSwiftExportDsl::class)`, Gradle warns that the API is experimental, so the build scripts in this sample opt in.

## Feature catalog

The app opens on a list of features. Every feature has a Kotlin file in `shared/src/commonMain/kotlin/com/github/jetbrains/swiftexport/` and a screen in `appleApp/appleApp/Features/` with the same name. The Kotlin file starts with a short comment describing what the construct becomes in Swift.

| Section | Feature | Kotlin | Swift screen | What it shows |
|---|---|---|---|---|
| Basics | Basics | `Basics.kt` | `BasicsView.swift` | Top-level functions and properties, primitive and unsigned types, nullability, overloads, `vararg` → variadic, `Any`, `@ObjCName(swiftName:)`, missing default arguments and the overload workaround |
| | Extensions | `Extensions.kt` | `ExtensionsView.swift` | Extension functions and properties → Swift extensions, extensions on nullable types |
| | Operators | `Operators.kt` | `OperatorsView.swift` | `+`, `*`, `<` from `compareTo`, subscripts from `get`, `~=` from `contains`, `callAsFunction` from `invoke`, `infix` |
| | Annotations & docs | `Annotations.kt` | `AnnotationsView.swift` | KDoc → Swift documentation, `@Deprecated` → `@available` incl. `DeprecationLevel.ERROR` → unavailable, `@HiddenFromObjC`, `@RequiresOptIn` → SPI |
| | Context parameters | `ContextParameters.kt` | `ContextParametersView.swift` | Context parameters as leading unlabeled Swift parameters |
| Type hierarchy | Classes | `Classes.kt` | `ClassesView.swift` | Final classes, nested and inner classes, typealiases, open and abstract classes, Swift subclasses that override open members and call `super`, `object` → `.shared`, companion objects, data and value classes, private constructors |
| | Interfaces | `Interfaces.kt` | `InterfacesView.swift` | Protocols, default methods, a Swift class implementing a Kotlin interface, `fun interface` |
| | Enums | `Enums.kt` | `EnumsView.swift` | Native Swift enums, exhaustive `switch`, `allCases`, `rawValue` |
| | Sealed types | `SealedTypes.kt` | `SealedTypesView.swift` | `sealedType()` → exhaustive `switch`, nested subclasses, `object` subclasses, sealed interfaces |
| Types | Collections | `Collections.kt` | `CollectionsView.swift` | `List`/`Set`/`Map` → Swift collections, `IntRange` → `ClosedRange`, mutable collections, `ByteArray`, `StringBuilder` |
| | Generics | `Generics.kt` | `GenericsView.swift` | Erased type parameters, generic classes and functions, Swift values passed as `Any` |
| | Function types | `FunctionTypes.kt` | `FunctionTypesView.swift` | Function types ↔ Swift closures, passing a Swift-only API (CryptoKit) to Kotlin |
| | Exceptions | `Exceptions.kt` | `ExceptionsView.swift` | `@Throws` → `throws`, catching Kotlin exceptions by type, exception payloads |
| Concurrency | Coroutines | `Coroutines.kt` | `CoroutinesView.swift` | `suspend` → `async throws`, suspend lambdas, `Flow` → `AsyncSequence`, `StateFlow.value`, setting a `MutableStateFlow` from Swift, cancelling a Swift `Task` cancels the coroutine |
| | Implementing in Swift | `SwiftImplementation.kt` | `SwiftImplementationView.swift` | A Swift class implementing a Kotlin interface with a `Flow` property and a `suspend fun`, using a Kotlin-provided `MutableStateFlow`; Kotlin code consumes it |
| Modules | Modules | `Modules.kt`, `:module-a`, `:module-b`, `:module-c`, `:module-d` | `ModulesView.swift` | One Swift module per exported Kotlin module, library vs. consumer configuration, `EXPOSED` dependencies |
| | Platform code | `Platform.kt`, `Platform.ios.kt`, `Platform.macos.kt` | `PlatformView.swift` | `iosMain`/`macosMain` code and `expect`/`actual` |
| | Hiding a dependency | `HiddenDependency.kt` | `HiddenDependencyView.swift` | Koin leaked into the public API, and `:module-d`, both hidden with `SwiftExportVisibility.HIDDEN` |

The catalog itself is `appleApp/appleApp/Catalog/FeatureCatalog.swift`; `DemoComponents.swift` next to it holds the shared row and screen views.

## Project structure

- `:shared` - The umbrella module, exported as the `Shared` Swift module. `xcodeIntegration {}` connects it to Xcode, and `swiftPackageIntegration {}` exports it as a Swift package. It depends on `:module-a` and `:module-b` via `api`, so both become separate Swift modules, and uses `kotlinx-coroutines` and Koin as `implementation` dependencies.
- `:module-a` - A Kotlin library that describes its own Swift representation (`ModuleA`) in its build script. This is what a library author would do.
- `:module-b` - A Kotlin library with no Swift export configuration at all. `:shared` decides how it appears in Swift (`ModuleB`). This is what a consumer does when a library says nothing about itself.
- `:module-c` - An `implementation` dependency of `:shared`. By default, Swift would only get the types that the `Shared` API uses. `:shared` exports the whole module as `ModuleC` with `SwiftExportVisibility.EXPOSED`.
- `:module-d` - Another `implementation` dependency, hidden from Swift with `SwiftExportVisibility.HIDDEN`. `Shared` has a class that inherits from its `Engine`, so Swift gets `Engine` as an empty stub with no members.
- `appleApp` - A SwiftUI app for iOS and macOS, built from a single multiplatform Xcode target. A Run Script build phase calls `:shared:embedSwiftExportForXcode` to build and embed the Kotlin code. The app's only screen lists the features with live results.
- `spm-consumer` - A plain Swift package that depends on the package produced by `:shared:exportDebugSwiftPackage`. It has a small executable and the language feature tests, which run on macOS with `swift test`.

`kotlinx-coroutines-core` is a plain `implementation` dependency of `:shared` and shows the default behavior. It gets its own `OrgJetbrainsKotlinxKotlinxCoroutinesCore` Swift module, which contains only the declarations the `Shared` API refers to, such as `Flow`.

## Swift export configuration

Swift export is configured in `build.gradle.kts` through the `export.swift {}` block inside the `kotlin {}` extension. The legacy `swiftExport {}` block is deprecated in Kotlin 2.5.0 and reports a diagnostic pointing to the new DSL.

### Umbrella module (`:shared`)

```kotlin
kotlin {
    iosArm64()
    iosSimulatorArm64()
    macosArm64()

    export {
        @OptIn(ExperimentalSwiftExportDsl::class)
        swift {
            // Root module name
            moduleName = "Shared"
            // Collapse rule
            rootPackage = "com.github.jetbrains.swiftexport"

            // Register :shared:embedSwiftExportForXcode task
            xcodeIntegration {
                reconfigureDependencies()
            }

            // Register :shared:exportDebugSwiftPackage and :shared:exportReleaseSwiftPackage tasks
            swiftPackageIntegration {
                reconfigureDependencies()
                // Default is "SwiftPackage" next to this build script
                outputDirectory = layout.projectDirectory.dir("SwiftPackage")
            }
        }
    }

    sourceSets.commonMain.dependencies {
        implementation(libs.kotlinx.coroutines.core)
        implementation(libs.koin.core)
        api(projects.moduleA)
        api(projects.moduleB)
        implementation(projects.moduleC)
        implementation(projects.moduleD)
    }
}

@OptIn(ExperimentalSwiftExportDsl::class)
fun SwiftExportIntegration.reconfigureDependencies() {
    // :module-b publishes no Swift export configuration, so the consumer names it
    configure(projects.moduleB) {
        moduleName = "ModuleB"
        rootPackage = "com.github.jetbrains.moduleb"
    }
    // :module-c is an implementation dependency, which would be exported only partially by default
    configure(projects.moduleC) {
        moduleName = "ModuleC"
        rootPackage = "com.github.jetbrains.modulec"
        visibility = SwiftExportVisibility.EXPOSED
    }
    // :module-d is not exported: types that the :shared API mentions become empty stubs
    configure(projects.moduleD, SwiftExportVisibility.HIDDEN)
    // Koin types leak into the exported API through HiddenDependency.kt: keep Koin out of
    // the Swift API, generating only empty stubs for its types
    configure(libs.koin.core, SwiftExportVisibility.HIDDEN)
}
```

Overrides are configured per integration. Both integrations need the same ones here, so they live in one function that both blocks call.

### Library module (`:module-a`)

```kotlin
kotlin {
    iosArm64()
    iosSimulatorArm64()
    macosArm64()

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

`:module-b`, `:module-c` and `:module-d` have no Swift export configuration of their own. `:shared` configures them with the `configure(...)` overrides. `:module-d` keeps the derived module name, `ModuleD`.

## How the new DSL works

Everything starts with `export.swift {}`. It replaces the old `swiftExport {}` block and takes two properties for the current module: `moduleName` and `rootPackage`. On its own, it doesn't register any build tasks for Xcode or Swift packages.

If `moduleName` is not set, it is derived from the Gradle project name with the dashes removed and CamelCase applied, so `module-b` becomes `ModuleB`. `:shared` still sets the names of `:module-b` and `:module-c` explicitly, so you can see them in the build script.

`rootPackage` is the old `flattenPackage` under a new name. Kotlin code normally lives in packages such as `com.github.jetbrains.modulea`. With `rootPackage` set, that prefix is dropped and the classes can be used from Swift directly.

The biggest change is that there is no `export(...)` list anymore. The dependency graph decides what gets exported. The full public API of each direct `api` dependency of the umbrella module is exported as a separate Swift module. Other dependencies, `implementation` and transitive ones alike, also get Swift modules, but those only contain the declarations that the exported API refers to.

A library configures its Swift representation once, the way `:module-a` does. When `moduleName` or `rootPackage` is set, the Kotlin Gradle plugin publishes them as a small metadata file next to the library, and consumers pick it up automatically. No integration block is needed for that. This works for project dependencies and for published external dependencies, so a consumer no longer repeats `moduleName` and `rootPackage` for every library it exports.

`xcodeIntegration {}` opts a module into Xcode and registers the `embedSwiftExportForXcode` task. `swiftPackageIntegration {}` registers the Swift package export tasks described below. Only `:shared` calls them. Inside each block, `configure(dependency) { ... }` reconfigures an exported dependency, given as a project, a Maven coordinate, or a version catalog entry. A consumer override wins over the library's published metadata, and the metadata wins over the derived default. `:shared` uses this to set the root package of `:module-b`, which has no metadata of its own. Overrides are not published. They only apply to the module that declares them. An override for a dependency that isn't part of the export, or two modules ending up with the same Swift name, fails the build with a diagnostic.

The same `configure` block also accepts a `visibility`:

- `SwiftExportVisibility.EXPOSED` exports the full API of a dependency, as if it were an `api` dependency. The dependency can stay `implementation`, so other Gradle consumers of `:shared` don't see it. `:shared` does this with `:module-c`.
- `SwiftExportVisibility.HIDDEN` removes a dependency from the Swift API, even if it is an `api` dependency. Only empty stubs remain for the types that other modules mention. A stub is still a real Swift class, so `Shared.Car` can inherit from the stubbed `Engine` of `:module-d`.

The shorthand is `configure(dependency, SwiftExportVisibility.HIDDEN)`. Visibility applies to that one library, not to its dependencies.

### Migrating from the legacy DSL

| Legacy `swiftExport {}` | New `export.swift {}` |
|---|---|
| `swiftExport { ... }` | `export { swift { ... } }` |
| `flattenPackage = "..."` | `rootPackage = "..."` |
| `export(project(":module-a")) { ... }` | Declare `api(projects.moduleA)`; the library configures itself, or the consumer overrides it via `xcodeIntegration { configure(projects.moduleA) { ... } }` |
| `embedSwiftExportForXcode` registered implicitly | Registered when `xcodeIntegration()` is called |
| `configure { freeCompilerArgs.add(...) }` | Removed |

## Swift package export

`swiftPackageIntegration {}` registers one export task per build type:

| Task | Output |
|---|---|
| `:shared:exportDebugSwiftPackage` | `shared/SwiftPackage/Debug` |
| `:shared:exportReleaseSwiftPackage` | `shared/SwiftPackage/Release` |

The package has a `Package.swift`, the generated Swift sources of every exported module, and the compiled Kotlin code in `SharedKotlin.xcframework`. The XCFramework has a slice per platform, here `ios-arm64`, `ios-arm64-simulator` and `macos-arm64`. All modules are available through one `SharedLibrary` product. The generated code needs iOS 18 or macOS 15 at minimum.

If the API differs between targets, the generated sources use `#if os(...)` branches. In this sample, `iosMain` and `macosMain` declare different `platformName()` implementations, and `iosBar()` exists on iOS only.

Add `outputDirectory/Debug` or `outputDirectory/Release` as a local package, not `outputDirectory` itself. `spm-consumer/Package.swift` does it like this:

```swift
dependencies: [
    .package(name: "Shared", path: "../shared/SwiftPackage/Debug"),
],
targets: [
    .executableTarget(
        name: "SpmConsumer",
        dependencies: [.product(name: "SharedLibrary", package: "Shared")]
    ),
]
```

In Xcode, use **File > Add Package Dependencies… > Add Local…**, select `shared/SwiftPackage/Debug`, and link `SharedLibrary`.

In Kotlin 2.5.0, you can't combine Swift package export with `swiftPMDependencies {}`. Support for this combination is planned for Kotlin 2.5.20.

## Language features

The Kotlin API of `:shared` is split into one file per topic. Comments in each file say what the declarations turn into in Swift. The tests in `spm-consumer/Tests/SwiftExportTests` call them from Swift.

| Kotlin source | Swift tests | Covers |
|---|---|---|
| `Basics.kt` | `BasicsTests.swift` | Top-level functions and properties, `const val`, primitive and unsigned types, `Char`, nullability, overloads, `vararg`, `Any`, `Unit`, `Nothing` |
| `ContextParameters.kt` | `BasicsTests.swift` | Context parameters as leading unlabeled Swift parameters |
| `Classes.kt` | `ClassesTests.swift` | Classes, secondary constructors, nested and inner classes, type aliases, open and abstract classes, Swift subclasses that override open methods and properties and call `super`, objects, companion objects, data classes, value classes, property visibility, `lateinit` |
| `Interfaces.kt` | `InterfacesTests.swift` | Interfaces as Swift protocols, default methods, Swift classes implementing Kotlin interfaces, `fun interface` |
| `SealedTypes.kt`, `Enums.kt` | `SealedAndEnumTests.swift` | Sealed classes and interfaces with exhaustive `switch` over `sealedType()`, enum classes as native Swift enums |
| `Generics.kt` | `TypesTests.swift` | Generic classes and functions (type-erased) |
| `Collections.kt` | `TypesTests.swift` | `List`, `Set` and `Map` as Swift collections, ranges, mutable collections, `ByteArray` and `StringBuilder` from the `KotlinStdlib` module |
| `Operators.kt` | `TypesTests.swift` | Arithmetic and comparison operators, subscripts, `contains`, `invoke` as `callAsFunction`, `infix` |
| `Extensions.kt` | `TypesTests.swift` | Extension functions and properties on Kotlin and Swift types, on nullable types |
| `FunctionTypes.kt` | `TypesTests.swift` | Function types as Swift closures, Swift implementations of Kotlin-declared dependencies |
| `Coroutines.kt` | `CoroutinesTests.swift` | `suspend` functions as `async`, Swift overrides of `suspend` functions, `Flow` and `SharedFlow` as `AsyncSequence`, `StateFlow.value`, settable `MutableStateFlow.value`, suspend function types, cancellation |
| `Exceptions.kt` | `ExceptionsTests.swift` | `@Throws` functions and constructors as Swift `throws` |
| `Annotations.kt` | `AnnotationsTests.swift`, `ClassesTests.swift` | KDoc as Swift documentation comments, `@ObjCName`, `@HiddenFromObjC`, `@Deprecated` as `@available(*, deprecated)`, `@RequiresOptIn` as Swift SPI |
| `nested/NestedPackage.kt` | `BasicsTests.swift` | Packages outside of `rootPackage` as Swift namespaces |
| `iosMain`, `macosMain` | `appleApp/Tests/Tests.swift`, `ModulesTests.swift` | Platform-specific API, UIKit and Foundation types |

`appleApp/Tests/Tests.swift` runs the same checks with XCTest against the modules that `embedSwiftExportForXcode` embeds in the app, on both iOS and macOS. The UIKit checks only run on iOS.

A declaration that needs an opt-in in Kotlin is only visible to Swift through an SPI import. The SPI name is the annotation's fully qualified name, with `$` in place of the dots:

```swift
@_spi(com$github$jetbrains$swiftexport$ExperimentalSampleApi) import Shared
```

To use a Swift-only API from Kotlin, declare a function type in Kotlin and let Swift provide the implementation as a closure. `FunctionTypes.kt` declares an MD5 hasher this way, and the Swift side implements it with CryptoKit.

### Known limitations

Some things don't map to Swift yet. The sample runs into these:

- Default argument values are not exported, so Swift callers pass every argument (`formatPrice`).
- Generics are erased. Type parameters become `(any KotlinRuntimeSupport._KotlinBridgeable)?`, so Swift has to cast values (`Box`).
- Data classes get `copy`, but no `componentN` functions. `==`, `hashValue` and `description` come from `NSObject`, which Kotlin wires to `equals`, `hashCode` and `toString`.
- Mutable collections and arrays stay Kotlin types rather than Swift collections (`mutableNames()`). `compareTo` gives you `<` and `>`, but no `Comparable` conformance.
- A Swift class that implements a Kotlin interface must inherit from an exported Kotlin class (`GreetingBase`), because `KotlinBase` can't be instantiated from Swift ([KT-88251](https://youtrack.jetbrains.com/issue/KT-88251)).
- Swift names can clash with SDK names. SwiftUI also declares `Shape`, so `appleApp` writes `Shared.Shape`.

## Hiding a dependency

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
- The same visibility hides `:module-d`: its `Engine` becomes an empty stub, and `Shared.Car` can still inherit from it.

HIDDEN is also the way out when a dependency's generated code doesn't compile. Hide the dependency, then make sure no Swift-facing declaration mentions its types.

## Not supported or different from Objective-C export

These are visible in the sample as workarounds, or not shown at all:

- Default argument values are not exported. Swift passes every argument; add Kotlin overloads for common cases (`formatPrice` in `Basics.kt`).
- Generics are erased, so values of type parameters must be cast in Swift. A bare Swift integer literal passed as `Any` arrives in Kotlin as `Double`; use `Int32(7)`.
- `protected` members, `inline` functions with `reified` type parameters, and companion blocks/static extensions are not exported.
- Mutable collections are not converted to Swift collections; keep read-only `List`, `Set` and `Map` in Swift-facing signatures.
- Abstract members that a Swift subclass doesn't override compile, but trap at runtime.
- An exception thrown from a function without `@Throws` terminates the app.

## Getting started

### Running the app

You need Xcode 16 or later and a JDK. Xcode 16 is the first version that opens the project format and has the iOS 18 and macOS 15 SDKs. The sample is developed with Xcode 27, and CI uses JDK 21.

1. Clone this repository.
2. Open `appleApp/appleApp.xcodeproj` in Xcode.
3. Pick an iOS simulator or **My Mac** as the run destination, then build and run the `appleApp` scheme. The Run Script build phase calls `./gradlew :shared:embedSwiftExportForXcode`, which builds the Kotlin code for the selected platform, so there is nothing to build by hand first.
4. Run the tests with **Product > Test**.

The macOS build is signed to run locally, so it doesn't need a development team. The iOS simulator build doesn't need one either. To run on an iPhone, set `TEAM_ID` in `appleApp/Configuration/Config.xcconfig`.

The project follows the current Xcode multiplatform app template, with two deliberate differences:

- User script sandboxing is off for the `appleApp` target, because the Run Script phase runs Gradle, which reads and writes outside the sandbox.
- Default main actor isolation is off. The generated Kotlin declarations are nonisolated, so with `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` every Swift override of a Kotlin member fails to compile ("different actor isolation from nonisolated overridden declaration").

The project turns on `MemberImportVisibility`, so a Swift file has to import every module whose members it uses. Members that Kotlin classes inherit from the standard library, such as `Throwable.message`, come from `KotlinStdlib`, so the app imports it explicitly.

### Consuming the Swift package

Export the package first, then build and test the consumer:

```shell
./gradlew :shared:exportDebugSwiftPackage
swift run --package-path spm-consumer
swift test --package-path spm-consumer
```

### Continuous integration

`.github/workflows/build.yml` runs two jobs on pushes and pull requests to `master`. One builds the app and its XCTests for the iOS simulator and for macOS, but doesn't run the XCTests, because GitHub's macOS runners don't reliably have a matching iOS simulator. The other exports the Swift package and runs `swift test` and `swift run` in `spm-consumer`, so the language feature tests run on every change. Run the XCTests locally with **Product > Test**.

### Working with AI coding agents

[`AGENTS.md`](AGENTS.md) has the commands to verify a change and the Swift export pitfalls this sample has run into. [`shared/AGENTS.md`](shared/AGENTS.md) and [`appleApp/AGENTS.md`](appleApp/AGENTS.md) add rules for the Kotlin API and the Xcode app, and agents read the file nearest to the code they change. Next to each `AGENTS.md`, a `CLAUDE.md` points Claude Code to it.

## Learn more

- [Interoperability with Swift using Swift export](https://kotlinlang.org/docs/native-swift-export.html)
- [What's new in Kotlin 2.5.0: Swift export goes Beta with a new Gradle DSL](https://kotlinlang.org/docs/whatsnew-eap.html#swift-export-goes-beta-with-a-new-gradle-dsl)
- [Moving from SKIE to Swift export in a Kotlin Multiplatform project](https://johnoreilly.dev/posts/peopleinspace-swift-export/) by John O'Reilly
- [Kotlin Multiplatform documentation](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html)
