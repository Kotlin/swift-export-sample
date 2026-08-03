import org.jetbrains.kotlin.gradle.swiftexport.ExperimentalSwiftExportDsl

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidMultiplatformLibrary)
}

kotlin {
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
        implementation(libs.kotlinx.coroutines.core)
        api(projects.moduleA)
        api(projects.moduleB)
    }

    android {
        namespace = "com.github.jetbrains.swiftexport"
        compileSdk = libs.versions.android.compileSdk.get().toInt()
        minSdk = libs.versions.android.minSdk.get().toInt()
    }
}

