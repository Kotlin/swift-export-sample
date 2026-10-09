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

fun greetEveryone(greetings: List<Greeting>, name: String): List<String> = greetings.map { it.greet(name) }

// Interfaces can also be implemented by Swift classes directly, and Kotlin calls
// back into the Swift implementation
interface Translator {
    val language: String

    fun translate(word: String): String

    fun translateAll(words: List<String>): List<String> = words.map { translate(it) }
}

class PigLatinTranslator : Translator {
    override val language: String = "Pig Latin"

    override fun translate(word: String): String =
        if (word.isEmpty()) word else word.drop(1) + word.first() + "ay"
}

fun defaultTranslator(): Translator = PigLatinTranslator()

fun translateSentence(sentence: String, translator: Translator): String =
    "[${translator.language}] " + translator.translateAll(sentence.split(" ")).joinToString(" ")

// Functional interfaces become protocols, plus a `validator(function:)` factory
// that turns a Swift closure into an implementation
fun interface Validator {
    fun validate(input: String): Boolean
}

fun notEmptyValidator(): Validator = Validator { it.isNotEmpty() }

fun validateAll(validator: Validator, inputs: List<String>): List<Boolean> = inputs.map(validator::validate)
