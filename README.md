[![official project](http://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

# Kotlin Swift Export Sample

This project demonstrates how to export Kotlin code as native Swift modules using JetBrains' Kotlin Multiplatform. The sample consists of three modules: `:shared`, `:module-a`, and `:module-b`, and showcases how to configure the DSL to export these Kotlin modules into Swift with custom configurations.

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

### Key Features

- **moduleName:** Allows setting a custom module name for the exported Kotlin module. For instance, the `:module-a` module is exported as `ModuleA` in Swift.
- **flattenPackage:** This is a package collapsing rule that simplifies package usage in Swift. In Kotlin, modules are typically organized within packages (e.g., `com.github.jetbrains.modulea`). By using `flattenPackage`, you can omit the package name and directly use classes from the module in Swift.

Learn more about [Kotlin Multiplatform](https://www.jetbrains.com/help/kotlin-multiplatform-dev/get-started.html)…