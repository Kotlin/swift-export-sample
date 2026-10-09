package com.github.jetbrains.swiftexport

// Collections
//
// Read-only `List`, `Set` and `Map` are native Swift `Array`, `Set` and `Dictionary`, copied on the
// way across. `IntRange` is a Swift `ClosedRange<Int32>`.
// Keep mutable collections out of Swift-facing signatures: they are not converted.

fun wordLengths(words: List<String>): Map<String, Int> = words.associateWith { it.length }

fun uniqueWords(text: String): Set<String> = text.lowercase().split(" ").filter { it.isNotEmpty() }.toSet()

fun digits(): IntRange = 0..9

fun evensIn(range: IntRange): List<Int> = range.filter { it % 2 == 0 }
