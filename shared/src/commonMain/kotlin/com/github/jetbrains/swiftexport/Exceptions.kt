package com.github.jetbrains.swiftexport

class ValidationException(message: String) : Exception(message)

// Functions annotated with @Throws become Swift `throws` functions.
// Kotlin's Throwable conforms to Swift's Error, so Swift catches the Kotlin exception
// as its own type: `catch let error as ValidationException`.
@Throws(ValidationException::class)
fun parseAge(input: String): Int {
    val age = input.toIntOrNull() ?: throw ValidationException("'$input' is not a number")
    if (age < 0) throw ValidationException("Age cannot be negative")
    return age
}

// Constructors can throw too
class PositiveNumber @Throws(IllegalArgumentException::class) constructor(val value: Int) {
    init {
        require(value > 0) { "$value is not positive" }
    }
}
