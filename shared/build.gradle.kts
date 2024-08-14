import org.jetbrains.kotlin.swiftexport.ExperimentalSwiftExportDsl

plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

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

