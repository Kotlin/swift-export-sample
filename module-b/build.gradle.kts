plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

version = "1.0.2"

kotlin {
    iosX64()
    iosArm64()
    iosSimulatorArm64()
}