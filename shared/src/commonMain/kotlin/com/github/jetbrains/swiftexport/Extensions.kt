package com.github.jetbrains.swiftexport

// Extensions on Kotlin types and on bridged Swift types become Swift extensions.
fun String.shout(): String = uppercase() + "!"

fun String.repeated(times: Int): String = repeat(times)

val String.wordCount: Int get() = split(" ").count { it.isNotBlank() }

fun Int.isEven(): Boolean = this % 2 == 0

fun Point.distanceTo(other: Point): Double {
    val dx = (x - other.x).toDouble()
    val dy = (y - other.y).toDouble()
    return kotlin.math.sqrt(dx * dx + dy * dy)
}

var Account.formattedBalance: String
    get() = "$owner: $balance"
    set(value) {
        nickname = value
    }

// Extensions on nullable types
fun String?.orDefault(): String = this ?: "default"
