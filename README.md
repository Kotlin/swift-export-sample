[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

# Kotlin Swift Export Sample

This project demonstrates how to export Kotlin code as native Swift modules using JetBrains' Kotlin Multiplatform. The sample consists of three modules: `:shared`, `:module-a`, and `:module-b`, showcasing how to configure the new Swift Export DSL introduced in Kotlin 2.5.0 to export these Kotlin modules into Swift with custom configurations.

## ⚠️ Experimental feature notice

**Swift Export is an experimental feature and subject to change in any future releases.** It may not function as expected, and you may encounter bugs. This project is an early technology demonstration and is **not production-ready**. Use it at your own risk.

## Project structure

- `:shared` - The umbrella module. It is exported as the `Shared` Swift module and is the only module wired into Xcode. It depends on `:module-a` and `:module-b` via `api`, so both end up as separate Swift modules.
- `:module-a` - A Kotlin library that describes its own Swift representation (`ModuleA`) in its build script. This is what a library author would do.
- `:module-b` - A Kotlin library with no Swift Export configuration at all. `:shared` decides how it appears in Swift (`ModuleB`). This is what a consumer does when a library says nothing about itself.

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
            }
        }
    }

    sourceSets.commonMain.dependencies {
        implementation(libs.kotlinx.coroutines.core)
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

The same `configure` block also accepts a `visibility`. `SwiftExportVisibility.EXPOSED` forces a dependency to be fully exported even if it is not an `api` dependency, and `SwiftExportVisibility.HIDDEN` does the opposite. There is a shorthand, `configure(dependency, SwiftExportVisibility.HIDDEN)`. This sample does not use either.

### Migrating from the legacy DSL

| Legacy `swiftExport {}` | New `export.swift {}` |
|---|---|
| `swiftExport { ... }` | `export { swift { ... } }` |
| `flattenPackage = "..."` | `rootPackage = "..."` |
| `export(project(":module-a")) { ... }` | Declare `api(projects.moduleA)`; the library configures itself, or the consumer overrides it via `xcodeIntegration { configure(projects.moduleA) { ... } }` |
| `embedSwiftExportForXcode` registered implicitly | Registered only when `xcodeIntegration()` is called |

## Getting started

### Running the project

1. Clone this repository.
2. Open the project `iosApp/iosApp.xcodeproj` with Xcode (tested with version 16.0).
3. Ensure you have the following command in your Run Script build phase: `./gradlew :shared:embedSwiftExportForXcode`.
4. Build the project. The Swift modules will be generated and can be found in the build output directory.

## Learn more

- [Interoperability with Swift using Swift export](https://kotlinlang.org/docs/native-swift-export.html)
- For more information on Kotlin Multiplatform, check out the [Kotlin Multiplatform Documentation](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html).
