package com.github.jetbrains.swiftexport

// Classes
//
// Kotlin final classes become `public final class X: KotlinBase` with an `init` per constructor.
// Nested classes stay nested (`Rectangle.Corner`), and typealiases are exported as Swift typealiases.

class Rectangle(val width: Int, val height: Int) {
    class Corner(val x: Int, val y: Int)

    fun area(): Int = width * height
}

typealias Corner = Rectangle.Corner

fun rectangleFrom(origin: Corner, opposite: Corner): Rectangle =
    Rectangle(opposite.x - origin.x, opposite.y - origin.y)
