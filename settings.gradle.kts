rootProject.name = "swift-export-sample"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositories {
        mavenCentral()
        ivy {
            url = uri("https://download.jetbrains.com/kotlin/native/builds/dev")
            patternLayout {
                artifact("[revision]/[classifier]/[artifact]-[classifier]-[revision].[ext]")
            }
            metadataSources {
                artifact()
            }
        }
    }
}

include(":shared")
include(":module-a")
include(":module-b")
include(":module-c")
include(":module-d")
