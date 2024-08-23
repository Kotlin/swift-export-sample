[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

# Kotlin Swift Export Sample

This project demonstrates how to export Kotlin code as native Swift modules using JetBrains' Kotlin Multiplatform. The sample consists of three modules: `:shared`, `:module-a`, and `:module-b`, showcasing how to configure the DSL to export these Kotlin modules into Swift with custom configurations.

## ⚠️ Experimental Feature Notice

**Swift Export is an experimental feature and subject to change in any future releases.** It may not function as expected, and you may encounter bugs. This project serves as an early technology demonstration and is **not production-ready**. Use it at your own risk.

## Project Structure

- `:shared` - The main shared module that aggregates and exports the other modules (`:module-a` and `:module-b`) as native Swift modules.
- `:module-a` - A sample Kotlin module to be exported as `ModuleA` in Swift.
- `:module-b` - Another sample Kotlin module to be exported as `ModuleB` in Swift.

## Swift Export Configuration

The export process is configured in the `build.gradle.kts` file within the `kotlin {}` block. Below is the configuration:

```kotlin
kotlin {
    iosX64()
    iosArm64()
    iosSimulatorArm64()

    @OptIn(ExperimentalSwiftExportDsl::class)
    swiftExport {
        // Root module name
        moduleName = "Shared"

        // Collapse rule
        flattenPackage = "com.github.jetbrains.swiftexport"

        // Export external modules
        export(project(":module-a")) {
            // Exported module name
            moduleName = "ModuleA"
            // Collapse exported dependency rule
            flattenPackage = "com.github.jetbrains.modulea"
        }

        export(project(":module-b")) {
            // Exported module name
            moduleName = "ModuleB"
            // Collapse exported dependency rule
            flattenPackage = "com.github.jetbrains.moduleb"
        }
    }

    sourceSets.commonMain.dependencies {
        api(project(":module-a"))
        api(project(":module-b"))
    }
}
```

## Getting Started

### Prerequisites

- Enable Swift Export by adding `kotlin.experimental.swift-export.enabled=true` to your `local.properties` or `gradle.properties`.

### Running the Project

1. Clone this repository.
2. Open the project `iosApp/iosApp.xcodeproj` with Xcode (tested with version 15.4).
3. Ensure you have the following command in your Run Script build phase: `./gradlew :shared:embedSwiftExportForXcode`.
4. Build the project. The Swift modules will be generated and can be found in the build output directory.

## Key Features

- **moduleName:** Allows setting a custom module name for the exported Kotlin module. For instance, the `:module-a` module is exported as `ModuleA` in Swift.
- **flattenPackage:** A package collapsing rule that simplifies package usage in Swift. In Kotlin, modules are typically organized within packages (e.g., `com.github.jetbrains.modulea`). Using `flattenPackage`, you can omit the package name and directly use classes from the module in Swift.

## Learn More

- For more information on Kotlin Multiplatform, check out the [Kotlin Multiplatform Documentation](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html).
