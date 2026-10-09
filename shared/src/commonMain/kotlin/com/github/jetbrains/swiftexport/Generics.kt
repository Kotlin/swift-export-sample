package com.github.jetbrains.swiftexport

// Generic types are exported with type erasure:
// type parameters become `(any _KotlinBridgeable)?` in Swift.
class Box<T>(val value: T) {
    fun <R> map(transform: (T) -> R): Box<R> = Box(transform(value))

    fun describe(): String = "Box($value)"
}

fun <T> boxOf(value: T): Box<T> = Box(value)

fun <T> firstOrNull(items: List<T>): T? = items.firstOrNull()

// Generic functions work with any bridgeable Swift value
object TypeChecker {
    enum class ReceivedType {
        IsString,
        IsInt,
        IsList,
        IsOther,
    }

    fun <T> checkType(input: T): ReceivedType = when (input) {
        is String -> ReceivedType.IsString
        is Int -> ReceivedType.IsInt
        is List<*> -> ReceivedType.IsList
        else -> ReceivedType.IsOther
    }
}
