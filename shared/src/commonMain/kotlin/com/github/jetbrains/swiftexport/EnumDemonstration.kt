package com.github.jetbrains.swiftexport

enum class EnumDemonstration(var i: Int, private val s: String) {
    FirstCase(1, "str"),
    SecondCase(5, "rts");
}

fun EnumDemonstration() = EnumDemonstration.FirstCase