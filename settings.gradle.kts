rootProject.name = "swift-export-sample"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
    repositories {
        maven("https://maven.pkg.jetbrains.space/kotlin/p/kotlin/bootstrap/") {}
        gradlePluginPortal()
        mavenCentral()

    }
}

dependencyResolutionManagement {
    repositories {
        maven("https://maven.pkg.jetbrains.space/kotlin/p/kotlin/bootstrap/") {}
        mavenCentral()
    }
}

include(":shared")
include(":module-a")
include(":module-b")