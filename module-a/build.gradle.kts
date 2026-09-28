import org.jetbrains.kotlin.gradle.swiftexport.ExperimentalSwiftExportDsl

plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

version = "1.0.5"

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