package com.github.jetbrains.swiftexport

// Operator functions become Swift operators.
class Vector(val x: Double, val y: Double) {
    operator fun plus(other: Vector): Vector = Vector(x + other.x, y + other.y)
    operator fun minus(other: Vector): Vector = Vector(x - other.x, y - other.y)
    operator fun times(factor: Double): Vector = Vector(x * factor, y * factor)
    operator fun unaryMinus(): Vector = Vector(-x, -y)

    // compareTo provides <, <=, >, >=
    operator fun compareTo(other: Vector): Int = length().compareTo(other.length())

    fun length(): Double = kotlin.math.sqrt(x * x + y * y)

    override fun toString(): String = "Vector($x, $y)"
}

// get/set become a Swift subscript, contains becomes `contains(other:)` and `~=`
class Grid(val width: Int, val height: Int) {
    private val cells = IntArray(width * height)

    operator fun get(index: Int): Int = cells[index]
    operator fun set(index: Int, value: Int) {
        cells[index] = value
    }

    operator fun contains(value: Int): Boolean = value in cells
}

// invoke becomes callAsFunction
class Multiplier(private val factor: Int) {
    operator fun invoke(value: Int): Int = value * factor
}

// infix functions are regular methods
infix fun Int.power(exponent: Int): Long {
    var result = 1L
    repeat(exponent) { result *= this }
    return result
}
