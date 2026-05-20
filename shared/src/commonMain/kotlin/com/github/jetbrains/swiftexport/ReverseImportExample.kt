package com.github.jetbrains.swiftexport

// Example of reverse import

// 1. define a holder for a closure
class Platform(
    val md5hasher: (String) -> String
)

// 2. use that provided closure
// https://kotlinlang.org/docs/native-lib-import-stability.html#swift-library-import
fun reverseImportExample(platform: Platform): String {
    val hashed = platform.md5hasher("example")
    return hashed
}