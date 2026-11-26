package com.github.jetbrains.swiftexport

// A lambda with receiver becomes a Swift closure that takes the receiver as its first parameter.
// Swift has no implicit `this`, so the closure calls members on that parameter.

class ShoppingList {
    private val items = mutableListOf<String>()

    fun add(item: String) {
        items += item
    }

    fun items(): List<String> = items.toList()
}

// `ShoppingList.() -> Unit` becomes `(ShoppingList) -> Void`: `shoppingList { $0.add(item: "milk") }`
fun shoppingList(build: ShoppingList.() -> Unit): List<String> = ShoppingList().apply(build).items()

// The same builder called from Kotlin, where `this` is implicit
fun breakfast(): List<String> = shoppingList {
    add("eggs")
    add("coffee")
}

// Other parameters follow the receiver: `String.(Int) -> String` becomes `(String, Int32) -> String`
fun numbered(words: List<String>, label: String.(Int) -> String): List<String> =
    words.mapIndexed { index, word -> word.label(index + 1) }

// A returned lambda with receiver is a Swift closure too: `surroundWith(marker: "*")("bold")`
fun surroundWith(marker: String): String.() -> String = { "$marker$this$marker" }
