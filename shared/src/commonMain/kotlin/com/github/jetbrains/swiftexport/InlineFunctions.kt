package com.github.jetbrains.swiftexport

import kotlin.reflect.KClass

// An inline function is exported like a regular one: Swift calls a Kotlin bridge with the body inlined.
// Lambda parameters become ordinary escaping Swift closures.
inline fun countMatching(numbers: List<Int>, predicate: (Int) -> Boolean): Int = numbers.count(predicate)

// `crossinline` and `noinline` don't change the Swift signature
inline fun greeter(crossinline name: () -> String): () -> String = { "Hello, ${name()}!" }

// Inline properties and extensions are exported too: `Int32(7).squared`
inline val Int.squared: Int get() = this * this

// A function with a `reified` type parameter is not exported: Swift gets no declaration at all.
inline fun <reified T> filterType(items: List<Any?>): List<T> = items.filterIsInstance<T>()

// The usual non-reified alternative takes a `KClass`, which Swift can't pass:
// Swift sees the function as unavailable.
fun filterByClass(items: List<Any?>, type: KClass<*>): List<Any> = items.filterNotNull().filter { type.isInstance(it) }

// Wrap a reified call in a function with a concrete type, and export that instead
fun stringsIn(items: List<Any?>): List<String> = filterType<String>(items)
