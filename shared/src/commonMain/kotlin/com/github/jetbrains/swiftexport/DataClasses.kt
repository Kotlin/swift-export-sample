package com.github.jetbrains.swiftexport

import kotlin.jvm.JvmInline

// Data and value classes
//
// A data class is a final Swift class. Kotlin `equals`, `hashCode` and `toString` back Swift's
// `==`, `Hashable` and `description`, so instances work in `Set`s and as dictionary keys.
// `copy(...)` is exported with every parameter required; `componentN` is not.
// A value class is exported as a wrapper class: `UserId(raw: "42")`.

data class Point(val x: Int, val y: Int)

fun origin(): Point = Point(0, 0)

@JvmInline
value class UserId(val raw: String)

fun profileUrl(id: UserId): String = "https://example.com/users/${id.raw}"
