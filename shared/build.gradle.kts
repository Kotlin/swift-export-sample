import org.jetbrains.kotlin.gradle.plugin.mpp.export.SwiftExportVisibility
import org.jetbrains.kotlin.gradle.swiftexport.ExperimentalSwiftExportDsl

plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

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

