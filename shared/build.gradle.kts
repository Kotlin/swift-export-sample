import org.jetbrains.kotlin.gradle.plugin.mpp.export.SwiftExportIntegration
import org.jetbrains.kotlin.gradle.plugin.mpp.export.SwiftExportVisibility
import org.jetbrains.kotlin.gradle.swiftexport.ExperimentalSwiftExportDsl

plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

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
        // implementation dependency: only the types used by the exported API are exported
        implementation(libs.kotlinx.coroutines.core)
        // api dependencies: exported as separate Swift modules
        api(projects.moduleA)
        api(projects.moduleB)
        // implementation dependency, forced to be exported as a separate Swift module
        implementation(projects.moduleC)
        // implementation dependency, hidden from Swift entirely
        implementation(projects.moduleD)
    }
}

@OptIn(ExperimentalSwiftExportDsl::class)
fun SwiftExportIntegration.reconfigureDependencies() {
    // :module-b publishes no Swift Export configuration, so the consumer names it
    configure(projects.moduleB) {
        // Exported module name
        moduleName = "ModuleB"
        // Collapse exported dependency rule
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
}
