package com.github.jetbrains.swiftexport

object TypeSystemImprovements {
    enum class ReceivedType {
        IsString,
        IsInt,
        IsArray,
    }

    // crash at runtime before 2.4.0
    fun <T> chackType(input: T): ReceivedType = when(input) {
        is String -> ReceivedType.IsString
        is Int -> ReceivedType.IsInt
        is List<*> -> ReceivedType.IsArray
        else -> error("the end of the demo :)")
    }

}