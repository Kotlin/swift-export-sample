package com.github.jetbrains.swiftexport

// Enum classes become native Swift enums which conform to
// CaseIterable, RawRepresentable and LosslessStringConvertible.
enum class Planet(val massKg: Double, val radiusM: Double) {
    Mercury(3.303e+23, 2.4397e6),
    Earth(5.976e+24, 6.37814e6),
    Jupiter(1.9e+27, 7.1492e7);

    val surfaceGravity: Double get() = 6.67300E-11 * massKg / (radiusM * radiusM)

    fun next(): Planet = entries[(ordinal + 1) % entries.size]
}

enum class Direction {
    North, East, South, West;

    // Members of the enum class are members of the Swift enum
    val opposite: Direction
        get() = when (this) {
            North -> South
            East -> West
            South -> North
            West -> East
        }
}

fun homePlanet(): Planet = Planet.Earth
