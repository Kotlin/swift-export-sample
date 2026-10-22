package com.github.jetbrains.swiftexport

// Interfaces become Swift protocols. Values are typed as `any Greeting`.
interface Greeting {
    val language: String

    fun greet(name: String): String

    // Default implementations are available to Swift as well
    fun greetAll(names: List<String>): List<String> = names.map { greet(it) }
}

class EnglishGreeting : Greeting {
    override val language: String = "English"
    override fun greet(name: String): String = "Hello, $name!"
}

class GermanGreeting : Greeting {
    override val language: String = "German"
    override fun greet(name: String): String = "Hallo, $name!"
}

fun greetings(): List<Greeting> = listOf(EnglishGreeting(), GermanGreeting())

// Swift classes can implement Kotlin interfaces too. Such a class has to inherit
// from an exported Kotlin class, because KotlinBase itself can't be instantiated (KT-88251).
open class GreetingBase

fun greetEveryone(greetings: List<Greeting>, name: String): List<String> = greetings.map { it.greet(name) }

// Functional interfaces become protocols, plus a `validator(function:)` factory
// that turns a Swift closure into an implementation
fun interface Validator {
    fun validate(input: String): Boolean
}

fun notEmptyValidator(): Validator = Validator { it.isNotEmpty() }

fun validateAll(validator: Validator, inputs: List<String>): List<Boolean> = inputs.map(validator::validate)
