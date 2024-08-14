package com.github.jetbrains.swiftexport

import com.github.jetbrains.modulea.ClassFromA
import com.github.jetbrains.moduleb.ClassFromB

class MyClass(val property: Int) {

    class Nested(val nestedProperty: Int)
}

typealias MyNested = MyClass.Nested

fun sum(a: MyClass, b: MyNested): Int =
    a.property + b.nestedProperty

fun useClassFromA(): ClassFromA {
    return ClassFromA("class_A")
}

fun useClassFromB(): ClassFromB {
    return ClassFromB("class_B")
}

fun sharedFunction(): Int = 15