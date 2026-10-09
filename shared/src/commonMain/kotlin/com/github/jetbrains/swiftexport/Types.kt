package com.github.jetbrains.swiftexport

// Primitive types and nullability
//
// Kotlin `Int` is Swift `Int32` and `Long` is `Int64`; unsigned types map to `UInt8`…`UInt64`.
// `Char` is a UTF-16 code unit (`UInt16`), not a Swift `Character`.
// Nullable types are Swift optionals, including `Int32?`, without boxing.
// `Unit` is `Void` and `Nothing` is `Never`.

fun sizes(byte: Byte, short: Short, int: Int, long: Long): String =
    "${byte.toLong() + short + int + long}"

fun largestUInt(): UInt = UInt.MAX_VALUE

fun largestULong(): ULong = ULong.MAX_VALUE

fun firstLetter(text: String): Char = text.first()

fun parseAge(text: String): Int? = text.toIntOrNull()

fun lengthOrZero(text: String?): Int = text?.length ?: 0

fun log(message: String) {
    println(message)
}

fun unreachable(reason: String): Nothing = error(reason)
