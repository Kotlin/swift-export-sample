package com.github.jetbrains.swiftexport

// Enums
//
// Enum classes become native Swift enums: `switch` is exhaustive without `default`, cases keep the
// Kotlin spelling (`.NORTH`), and properties and methods are available on the cases.
// `allCases` replaces `entries`, `rawValue` is the ordinal and `description` is the name.

enum class Direction(val degrees: Int) {
    NORTH(0),
    EAST(90),
    SOUTH(180),
    WEST(270);

    fun turnRight(): Direction = entries[(ordinal + 1) % entries.size]
}

fun startingDirection(): Direction = Direction.NORTH
