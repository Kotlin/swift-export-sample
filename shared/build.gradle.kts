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


tasks.register("_testSwiftExportClasspath") {
    doLast {
        configurations.getByName("swiftExportClasspathResolvable").resolve()
    }
}

