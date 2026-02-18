plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

version = "1.0.2"

kotlin {
    iosArm64()
    iosSimulatorArm64()
}