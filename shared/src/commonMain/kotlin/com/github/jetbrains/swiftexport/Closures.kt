package com.github.jetbrains.swiftexport

// Closures
//
// Kotlin function types become Swift closures: `(String) -> String` in both directions.
// This is a simple way to hand a Swift-only capability (here: CryptoKit's MD5) to Kotlin code.

class TextHasher(val hash: (String) -> String)

fun fingerprint(text: String, hasher: TextHasher): String = "$text#${hasher.hash(text)}"

fun makeShouter(): (String) -> String = { it.uppercase() + "!" }
