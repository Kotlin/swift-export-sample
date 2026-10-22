plugins {
    alias(libs.plugins.kotlinMultiplatform)
}

version = "1.0.0"

kotlin {
    iosArm64()
    iosSimulatorArm64()
    macosArm64()
}
