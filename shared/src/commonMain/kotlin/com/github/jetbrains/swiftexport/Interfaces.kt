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

// Functional interfaces: `invoke`-style calls and a Swift closure-based factory
fun interface Validator {
    fun validate(input: String): Boolean
}

fun notEmptyValidator(): Validator = Validator { it.isNotEmpty() }

fun validateAll(validator: Validator, inputs: List<String>): List<Boolean> = inputs.map(validator::validate)
