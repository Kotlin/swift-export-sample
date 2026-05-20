rootProject.name = "swift-export-sample"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
    repositories {
        maven("https://redirector.kotlinlang.org/maven/dev")
        gradlePluginPortal()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositories {
        maven("https://redirector.kotlinlang.org/maven/dev")
        mavenCentral()
    }
}

include(":shared")
include(":module-a")
include(":module-b")