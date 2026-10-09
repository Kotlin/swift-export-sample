package com.github.jetbrains.swiftexport

// Functions
//
// Top-level functions of the `rootPackage` are global Swift functions; there is no `FileNameKt` class.
// Parameter names become argument labels. Overloads keep the same name and labels in Swift.

fun greet(name: String): String = "Hello, $name!"

fun describe(value: Int): String = "Int $value"
fun describe(value: Double): String = "Double $value"
fun describe(value: String): String = "String \"$value\""
