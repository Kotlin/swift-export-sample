package com.github.jetbrains.moduleb

class ClassFromB(private val name: String) {

    fun hello(): String {
        return "Hello from $name"
    }
}

fun moduleBFunction(): Int = 10