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
