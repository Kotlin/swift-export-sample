package com.github.jetbrains.swiftexport

// Generics
//
// Type parameters are erased: an unbounded `T` becomes `(any _KotlinBridgeable)?` in Swift.
// Swift values such as `String`, `[Int32]` or `Int32` can be passed directly and keep their Kotlin
// type at runtime. Before Kotlin 2.4.0 passing a Swift `String` here crashed.

enum class ValueKind {
    STRING,
    INT,
    LIST,
    OTHER,
}

fun <T> kindOf(value: T): ValueKind = when (value) {
    is String -> ValueKind.STRING
    is Int -> ValueKind.INT
    is List<*> -> ValueKind.LIST
    else -> ValueKind.OTHER
}
