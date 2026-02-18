plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

version = "1.0.5"

kotlin {
    iosArm64()
    iosSimulatorArm64()
}