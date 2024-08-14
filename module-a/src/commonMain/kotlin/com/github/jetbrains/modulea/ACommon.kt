package com.github.jetbrains.modulea

class ClassFromA(private val name: String) {

    fun hello(): String {
        return "Hello from $name"
    }
}

fun moduleAFunction(): Int = 5