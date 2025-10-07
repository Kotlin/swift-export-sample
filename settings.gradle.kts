rootProject.name = "swift-export-sample"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
    repositories {
        mavenLocal()
        maven("https://packages.jetbrains.team/maven/p/kt/bootstrap/") {}
        gradlePluginPortal()
        mavenCentral()

    }
}

dependencyResolutionManagement {
    repositories {
        mavenLocal()
        maven("https://packages.jetbrains.team/maven/p/kt/bootstrap/") {}
        mavenCentral()
    }
}

include(":shared")
include(":module-a")
include(":module-b")