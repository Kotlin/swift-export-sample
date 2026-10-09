package com.github.jetbrains.swiftexport

// Inheritance
//
// `open` and `abstract` Kotlin classes are `open` Swift classes; Kotlin subclasses are Swift subclasses.
// A Swift class can subclass a Kotlin class and override its open members, and calls from Kotlin
// are dispatched to the Swift override. Final members stay `final`.
// Abstract members that a Swift subclass doesn't override compile, but trap at runtime.

open class Animal(val name: String) {
    open fun sound(): String = "…"

    fun introduce(): String = "$name says ${sound()}"
}

class Dog(name: String) : Animal(name) {
    override fun sound(): String = "Woof"
}

fun introduceAll(animals: List<Animal>): List<String> = animals.map { it.introduce() }

abstract class Figure {
    abstract fun area(): Double

    fun describeArea(): String = "area ${(area() * 100).toInt() / 100.0}"
}

class Square(val side: Double) : Figure() {
    override fun area(): Double = side * side
}
