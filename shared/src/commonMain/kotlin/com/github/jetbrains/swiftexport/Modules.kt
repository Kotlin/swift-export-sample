package com.github.jetbrains.swiftexport

import com.github.jetbrains.modulea.ClassFromA
import com.github.jetbrains.moduleb.ClassFromB

// Modules
//
// `:module-a` and `:module-b` are `api` dependencies, so each becomes its own Swift module
// (`ModuleA`, `ModuleB`), and their types are referenced through those modules in the Swift
// API of `Shared`. `:module-a` names itself in its build script; `:shared` names `:module-b`
// via `configure(...)`.
fun useClassFromA(): ClassFromA = ClassFromA("class_A")

fun useClassFromB(): ClassFromB = ClassFromB("class_B")

// :module-c is an `implementation` dependency, but exported fully because of `SwiftExportVisibility.EXPOSED`
fun analytics(): com.github.jetbrains.modulec.Analytics = com.github.jetbrains.modulec.Analytics()

// :module-d is hidden with `SwiftExportVisibility.HIDDEN`. Engine is an empty stub in Swift,
// so Car can still inherit from it, but Engine's own members are not exported.
class Car : com.github.jetbrains.moduled.Engine() {
    fun drive(): String = "${start()}, driving"
}
