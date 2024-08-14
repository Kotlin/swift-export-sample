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
        export(projects.moduleA) {
            // Exported module name
            moduleName = "ModuleA"
            // Collapse exported dependency rule
            flattenPackage = "com.github.jetbrains.modulea"
        }

        export(projects.moduleB) {
            // Exported module name
            moduleName = "ModuleB"
            // Collapse exported dependency rule
            flattenPackage = "com.github.jetbrains.moduleb"
        }
    }

    sourceSets.commonMain.dependencies {
        api(projects.moduleA)
        api(projects.moduleB)
    }
}

