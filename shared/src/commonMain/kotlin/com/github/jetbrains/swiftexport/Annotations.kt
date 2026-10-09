@file:OptIn(ExperimentalObjCRefinement::class)

package com.github.jetbrains.swiftexport

import kotlin.experimental.ExperimentalObjCRefinement
import kotlin.native.HiddenFromObjC

// Annotations and documentation
//
// KDoc is exported as Swift documentation comments, so Xcode shows it in Quick Help.
// `@Deprecated` becomes `@available(*, deprecated)`; with `DeprecationLevel.ERROR` the declaration
// is unavailable in Swift. `@HiddenFromObjC` keeps a declaration out of Swift entirely.

/**
 * Returns the number of vowels in [text].
 *
 * Option-click `vowelCount(text:)` in Xcode to see this comment.
 */
fun vowelCount(text: String): Int = text.count { it.lowercaseChar() in "aeiou" }

@Deprecated("Use vowelCount(text) instead", ReplaceWith("vowelCount(text)"))
fun countVowels(text: String): Int = vowelCount(text)

@Deprecated("Removed, use vowelCount(text)", level = DeprecationLevel.ERROR)
fun vowels(text: String): Int = vowelCount(text)

@HiddenFromObjC
fun kotlinOnlyHelper(): String = "not visible from Swift"
