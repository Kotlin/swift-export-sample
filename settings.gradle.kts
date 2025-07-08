rootProject.name = "swift-export-sample"
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")

pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
        maven {
            url = uri("https://redirector.kotlinlang.org/maven/dev")
        }
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
    }
}

dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://redirector.kotlinlang.org/maven/dev")
        }
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