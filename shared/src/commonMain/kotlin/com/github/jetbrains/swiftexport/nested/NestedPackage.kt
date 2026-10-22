package com.github.jetbrains.swiftexport.nested

// Declarations outside of `rootPackage` keep their package as a Swift namespace:
// `ExportedKotlinPackages.com.github.jetbrains.swiftexport.nested.NestedPackageClass`
class NestedPackageClass {
    fun hello(): String = "Hello from a nested package"
}

fun nestedPackageFunction(): String = "nested"
