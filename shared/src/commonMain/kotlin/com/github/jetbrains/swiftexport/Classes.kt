package com.github.jetbrains.swiftexport

import com.github.jetbrains.modulea.ClassFromA
import com.github.jetbrains.moduleb.ClassFromB

// Final classes become `public final class ...: KotlinRuntime.KotlinBase`.
class MyClass(val property: Int) {
    // Secondary constructors are separate Swift initializers
    constructor(text: String) : this(text.length)

    // Nested classes stay nested in Swift: MyClass.Nested
    class Nested(val nestedProperty: Int)

    // Inner classes take the outer instance in their initializer
    inner class Inner {
        fun outerProperty(): Int = property
    }
}

// Type aliases become Swift type aliases
typealias MyNested = MyClass.Nested

fun sum(a: MyClass, b: MyNested): Int = a.property + b.nestedProperty

// Open and abstract classes can be subclassed, also from Swift
abstract class Shape(val name: String) {
    abstract fun area(): Double

    open fun describe(): String = "$name with area ${area()}"
}

open class Rectangle(val width: Double, val height: Double) : Shape("Rectangle") {
    override fun area(): Double = width * height
}

class Square(side: Double) : Rectangle(side, side) {
    override fun describe(): String = "Square: ${super.describe()}"
}

// Kotlin code that works with any Shape, including the ones implemented in Swift
fun totalArea(shapes: List<Shape>): Double = shapes.sumOf { it.area() }

fun describeAll(shapes: List<Shape>): List<String> = shapes.map { it.describe() }

// Objects are singletons, available as `.shared` in Swift
object Counter {
    var value: Int = 0
        private set

    fun increment(): Int = ++value
}

// Companion objects are nested `Companion` types with `.shared`
class Temperature private constructor(val celsius: Double) {
    val fahrenheit: Double get() = celsius * 9 / 5 + 32

    companion object {
        fun fromCelsius(value: Double): Temperature = Temperature(value)
        fun fromFahrenheit(value: Double): Temperature = Temperature((value - 32) * 5 / 9)
    }
}

// Data classes: `copy` is exported, while equals/hashCode/toString are
// available as Swift `==`, `hashValue` and `description`
data class Point(val x: Int, val y: Int)

// Value classes are exported as wrapper classes
value class Email(val value: String) {
    val domain: String get() = value.substringAfter('@')
}

fun email(value: String): Email = Email(value)

// Properties with private setters are read-only in Swift
class Account(val owner: String) {
    var balance: Long = 0
        private set

    // lateinit properties are ordinary properties in Swift
    lateinit var nickname: String

    fun deposit(amount: Long) {
        balance += amount
    }
}

// Types from other exported modules are referenced by their own Swift modules
fun useClassFromA(): ClassFromA = ClassFromA("class_A")

fun useClassFromB(): ClassFromB = ClassFromB("class_B")

// :module-c is an `implementation` dependency, but exported fully because of `SwiftExportVisibility.EXPOSED`
fun analytics(): com.github.jetbrains.modulec.Analytics = com.github.jetbrains.modulec.Analytics()
