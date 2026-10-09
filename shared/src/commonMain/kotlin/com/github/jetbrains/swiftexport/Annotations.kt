@file:OptIn(ExperimentalObjCName::class, ExperimentalObjCRefinement::class)

package com.github.jetbrains.swiftexport

import kotlin.experimental.ExperimentalObjCName
import kotlin.experimental.ExperimentalObjCRefinement
import kotlin.native.HiddenFromObjC
import kotlin.native.ObjCName

/**
 * KDoc comments become Swift documentation comments,
 * which are shown in Xcode quick help.
 *
 * @param name the name to greet
 * @return a greeting message
 */
fun documented(name: String): String = "Hello, $name"

// @ObjCName renames declarations in Swift
@ObjCName(swiftName = "SwiftFriendlyName")
class KotlinSpecificName {
    @ObjCName(swiftName = "run")
    fun execute(@ObjCName(swiftName = "_") value: Int): Int = value * 2
}

// @HiddenFromObjC hides declarations from Swift
@HiddenFromObjC
fun kotlinOnly(): String = "invisible from Swift"

// @Deprecated becomes @available(*, deprecated, ...)
@Deprecated("Use newApi() instead", ReplaceWith("newApi()"))
fun oldApi(): String = "old"

fun newApi(): String = "new"

/** Returns the number of vowels in [text]. */
fun vowelCount(text: String): Int = text.count { it.lowercaseChar() in "aeiou" }

// With `DeprecationLevel.ERROR` the declaration is unavailable in Swift
@Deprecated("Removed, use vowelCount(text)", level = DeprecationLevel.ERROR)
fun vowels(text: String): Int = vowelCount(text)

// Opt-in requirements become Swift SPI: Swift sees the declaration only with
// `@_spi(ExperimentalSampleApi) import Shared`
@RequiresOptIn(message = "This API is experimental", level = RequiresOptIn.Level.WARNING)
annotation class ExperimentalSampleApi

@ExperimentalSampleApi
fun experimentalGreeting(): String = "Hello from an experimental API"
