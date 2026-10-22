package com.github.jetbrains.swiftexport

// Kotlin function types become Swift closures, in both directions.
fun applyTwice(value: Int, transform: (Int) -> Int): Int = transform(transform(value))

fun makeMultiplier(factor: Int): (Int) -> Int = { it * factor }

fun transformAll(items: List<String>, transform: (String) -> String): List<String> = items.map(transform)

// Swift provides an implementation of a Kotlin-declared dependency through a closure.
// Kotlin can't call Swift-only APIs such as CryptoKit, so Swift passes a CryptoKit-based hasher as a closure.
class Platform(
    val md5hasher: (String) -> String
)

fun reverseImportExample(platform: Platform): String = platform.md5hasher("example")
