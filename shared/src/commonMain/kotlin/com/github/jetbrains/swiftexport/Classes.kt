package com.github.jetbrains.swiftexport

// Classes
//
// Kotlin final classes become `public final class X: KotlinBase` with an `init` per constructor.
// Nested classes stay nested (`Rectangle.Corner`), and typealiases are exported as Swift typealiases.
// An inner class takes its outer instance as the `outer__` argument.
// `object` is a singleton (`AppInfo.shared`); a companion object is `Temperature.Companion.shared`.
// A private constructor is not exported, so Swift has to use the companion factory.

class Rectangle(val width: Int, val height: Int) {
    class Corner(val x: Int, val y: Int)

    fun area(): Int = width * height
}

typealias Corner = Rectangle.Corner

fun rectangleFrom(origin: Corner, opposite: Corner): Rectangle =
    Rectangle(opposite.x - origin.x, opposite.y - origin.y)

class Counter {
    var value: Int = 0
        private set

    inner class Step(val by: Int) {
        fun apply(): Int {
            value += by
            return value
        }
    }
}

object AppInfo {
    val name: String = "Swift Export sample"

    fun banner(): String = "$name on ${platformName()}"
}

class Temperature private constructor(val celsius: Double) {
    companion object {
        val freezing: Temperature = Temperature(0.0)

        fun fromFahrenheit(fahrenheit: Double): Temperature = Temperature((fahrenheit - 32) * 5 / 9)
    }
}
