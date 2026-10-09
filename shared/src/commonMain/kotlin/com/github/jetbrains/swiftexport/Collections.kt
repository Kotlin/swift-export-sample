package com.github.jetbrains.swiftexport

// Read-only collections map to Swift collections:
// List -> Array, Set -> Set, Map -> Dictionary.
fun fibonacci(count: Int): List<Int> = generateSequence(0 to 1) { (a, b) -> b to a + b }
    .map { it.first }
    .take(count)
    .toList()

fun uniqueWords(text: String): Set<String> = text.lowercase().split(" ").filter { it.isNotBlank() }.toSet()

fun wordLengths(words: List<String>): Map<String, Int> = words.associateWith { it.length }

fun nestedLists(): List<List<Int>?> = listOf(listOf(1, 2), null, listOf(3))

// Ranges map to Swift ranges
fun digits(): IntRange = 0..9

fun isAdult(age: Int): Boolean = age in 18..Int.MAX_VALUE

// A range parameter becomes a Swift `ClosedRange<Int32>`
fun evensIn(range: IntRange): List<Int> = range.filter { it % 2 == 0 }

// Mutable collections and arrays stay Kotlin types
fun mutableNames(): MutableList<String> = mutableListOf("Kotlin", "Swift")

// ByteArray is `ExportedKotlinPackages.kotlin.ByteArray` from the KotlinStdlib module
fun bytesOf(text: String): ByteArray = text.encodeToByteArray()

fun checksum(bytes: ByteArray): Int = bytes.sum()

// Other stdlib classes are exported on demand, in the KotlinStdlib module
fun buildGreeting(builder: StringBuilder, name: String): String = builder.append("Hello, ").append(name).toString()
