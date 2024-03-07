plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

kotlin {
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Shared"
        }
    }
    
    sourceSets {
        commonMain
    }
}

configurations.getByName("swiftExportClasspathResolvable").resolutionStrategy {
    force("org.jetbrains.kotlin:swift-export-embeddable:2.0.0-titan-103")
}

tasks.register("_testSwiftExportClasspath") {
    doLast {
        configurations.getByName("swiftExportClasspathResolvable").resolve()
    }
}

