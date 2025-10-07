import org.jetbrains.kotlin.gradle.swiftexport.ExperimentalSwiftExportDsl
import org.jetbrains.kotlin.gradle.plugin.mpp.apple.swiftexport.SWIFT_EXPORT_COROUTINES_SUPPORT_TURNED_ON

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

        configure {
            settings.put(SWIFT_EXPORT_COROUTINES_SUPPORT_TURNED_ON, "true")
        }
    }

    sourceSets.commonMain.dependencies {
        api(projects.moduleA)
        api(projects.moduleB)
    }
}

