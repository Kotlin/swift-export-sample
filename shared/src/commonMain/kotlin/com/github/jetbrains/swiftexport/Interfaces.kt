package com.github.jetbrains.swiftexport

// Interfaces
//
// A Kotlin interface becomes a Swift protocol; values are `any Translator`.
// Default method bodies are inherited. A Swift class can implement the protocol if it also
// inherits `KotlinBase`, and Kotlin then calls into the Swift implementation.
// A `fun interface` is a protocol as well.

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

fun interface Validator {
    fun isValid(input: String): Boolean
}

fun nonEmptyValidator(): Validator = Validator { it.isNotBlank() }

fun countValid(inputs: List<String>, validator: Validator): Int = inputs.count { validator.isValid(it) }
