package com.github.jetbrains.moduled

// :shared hides this module from Swift with SwiftExportVisibility.HIDDEN,
// so none of these members are available to Swift.
open class Engine {
    open fun start(): String = "Engine started"
}

fun moduleDFunction(): Int = 3
