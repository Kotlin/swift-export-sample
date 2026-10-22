package com.github.jetbrains.swiftexport

// Top-level declarations become Swift global functions and properties.
// Thanks to `rootPackage`, they are available without the package prefix.

/** Compile-time constant, exported as a read-only Swift property. */
const val SAMPLE_NAME: String = "Swift Export Sample"

/** Read-only property: `public var answer: Int32 { get }`. */
val answer: Int = 42

/** Mutable property: `public var counter: Int32 { get set }`. */
var counter: Int = 0

fun sharedFunction(): Int = 15

fun increment(): Int = ++counter

// Primitive types map to the corresponding Swift types.
fun primitives(
    bool: Boolean,  // Swift.Bool
    byte: Byte,     // Swift.Int8
    short: Short,   // Swift.Int16
    int: Int,       // Swift.Int32
    long: Long,     // Swift.Int64
    float: Float,   // Swift.Float
    double: Double, // Swift.Double
): String = "$bool $byte $short $int $long $float $double"

// Unsigned types map to Swift unsigned integers
fun unsigned(value: UInt): ULong = value.toULong() * 2u

// Char is a UTF-16 code unit in Swift
fun charCode(char: Char): Int = char.code

// Nullable types become Swift optionals
fun greet(name: String?): String = "Hello, ${name ?: "stranger"}!"

fun findPositive(value: Int): Int? = value.takeIf { it > 0 }

// Overloads with different parameter types are kept
fun describe(value: Int): String = "Int $value"
fun describe(value: Double): String = "Double $value"
fun describe(value: String): String = "String \"$value\""

// vararg becomes a Swift variadic parameter
fun sumAll(vararg numbers: Int): Int = numbers.sum()

// Default arguments are not supported yet: Swift callers pass every argument
fun formatPrice(amount: Double, currency: String = "EUR"): String = "$amount $currency"

// Any is exported as `any KotlinRuntimeSupport._KotlinBridgeable`
fun typeOf(value: Any): String = when (value) {
    is String -> "String"
    is Int -> "Int"
    is List<*> -> "List"
    else -> value::class.simpleName ?: "Unknown"
}

// Unit is Swift.Void, Nothing is Swift.Never
fun doNothing() {}

fun fail(message: String): Nothing = throw IllegalStateException(message)
