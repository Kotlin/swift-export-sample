package com.github.jetbrains.swiftexport

// Extensions
//
// Extension functions and properties declared in the `rootPackage` become real Swift extensions:
// `"Hi".repeated(times: 3)`, `"a b".wordCount`. Outside the root package they are static functions
// that take the receiver as the first argument.

fun String.repeated(times: Int): String = List(times) { this }.joinToString(" ")

val String.wordCount: Int get() = split(" ").count { it.isNotBlank() }
