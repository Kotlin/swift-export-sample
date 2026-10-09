package com.github.jetbrains.swiftexport

import com.github.jetbrains.modulea.ClassFromA
import com.github.jetbrains.moduleb.ClassFromB

// Modules
//
// `:module-a` and `:module-b` are `api` dependencies, so each becomes its own Swift module
// (`ModuleA`, `ModuleB`). Types from them can be used freely in the API of `Shared`.
// `:module-a` names itself in its build script; `:shared` names `:module-b` via `configure(...)`.

fun makeClassFromA(): ClassFromA = ClassFromA("class_A")

fun makeClassFromB(): ClassFromB = ClassFromB("class_B")
