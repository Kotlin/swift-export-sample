@file:OptIn(ExperimentalObjCName::class)

package com.github.jetbrains.swiftexport

import kotlin.experimental.ExperimentalObjCName
import kotlin.native.ObjCName

// Functions
//
// Top-level functions of the `rootPackage` are global Swift functions; there is no `FileNameKt` class.
// Parameter names become argument labels. Overloads keep the same name and labels in Swift.
// `vararg` becomes a Swift variadic parameter. `@ObjCName(swiftName = ...)` renames a declaration.
// Default argument values are not exported: Swift must pass every argument, so add an overload
// for the common case.

fun greet(name: String): String = "Hello, $name!"

fun describe(value: Int): String = "Int $value"
fun describe(value: Double): String = "Double $value"
fun describe(value: String): String = "String \"$value\""

fun total(vararg numbers: Int): Int = numbers.sum()

@ObjCName(swiftName = "shout")
fun makeLoud(text: String): String = text.uppercase()

fun formatPrice(amount: Double, currency: String = "EUR"): String = "$amount $currency"
fun formatPrice(amount: Double): String = formatPrice(amount, "EUR")
