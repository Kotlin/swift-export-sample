package com.github.jetbrains.swiftexport

// Generics
//
// Type parameters are erased: an unbounded `T` becomes `(any _KotlinBridgeable)?` in Swift,
// and a generic class like `Box<T>` is a plain `Box` whose `value` must be cast back.
// Swift values such as `String`, `[Int32]` or `Int32` can be passed directly and keep their Kotlin
// type at runtime. Before Kotlin 2.4.0 passing a Swift `String` here crashed.
// A bare Swift integer literal is not `Int32`: it arrives in Kotlin as a `Double`.

enum class ValueKind {
    STRING,
    INT,
    DOUBLE,
    LIST,
    OTHER,
}

fun <T> kindOf(value: T): ValueKind = when (value) {
    is String -> ValueKind.STRING
    is Int -> ValueKind.INT
    is Double -> ValueKind.DOUBLE
    is List<*> -> ValueKind.LIST
    else -> ValueKind.OTHER
}

class Box<T>(val value: T) {
    fun describe(): String = "Box($value)"
}

fun boxedGreeting(): Box<String> = Box("hello")
