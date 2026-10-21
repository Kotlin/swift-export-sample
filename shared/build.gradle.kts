import org.jetbrains.kotlin.gradle.plugin.mpp.export.SwiftExportIntegration
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

            // Register :shared:embedSwiftExportForXcode task
            xcodeIntegration {
                reconfigurePackages()
            }

            // Register :shared:exportDebugSwiftPackage and :shared:exportReleaseSwiftPackage tasks
            swiftPackageIntegration {
                reconfigurePackages()
            }
        }
    }

    sourceSets.commonMain.dependencies {
        implementation(libs.kotlinx.coroutines.core)
        api(projects.moduleA)
        api(projects.moduleB)
    }
}

@OptIn(ExperimentalSwiftExportDsl::class)
fun SwiftExportIntegration.reconfigurePackages() {
    // Explicitly reconfigure exported module
    configure(projects.moduleB) {
        // Exported module name
        moduleName = "ModuleB"
        // Collapse exported dependency rule
        rootPackage = "com.github.jetbrains.moduleb"
    }
}