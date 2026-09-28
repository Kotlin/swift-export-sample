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
            }
        }
    }

    sourceSets.commonMain.dependencies {
        implementation(libs.kotlinx.coroutines.core)
        api(projects.moduleA)
        api(projects.moduleB)
    }
}

