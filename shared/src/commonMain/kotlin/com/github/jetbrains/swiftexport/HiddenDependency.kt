package com.github.jetbrains.swiftexport

import org.koin.core.Koin
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.module

// Hiding a dependency (Koin)
//
// Koin is an `implementation` dependency, but `AppGraph.koin` and `AppGraph.modules()` mention Koin
// types in the public API by accident. Swift Export would follow them and export Koin as well.
// `:shared` hides Koin with `configure(libs.koin.core, SwiftExportVisibility.HIDDEN)`: Koin's types
// become empty stubs, and the leaked declarations still compile in Swift but trap when called.
// The fix is to expose only your own types, like `AppGraph.greetingService()`.

class GreetingService(private val greeting: String) {
    fun welcome(name: String): String = "$greeting, $name! (resolved by Koin)"
}

private val appModule: Module = module {
    single { GreetingService("Welcome") }
}

object AppGraph {
    // Accidental leaks: public declarations that mention Koin types.
    val koin: Koin by lazy { startKoin { modules(appModule) }.koin }

    fun modules(): List<Module> = listOf(appModule)

    // Swift-facing API: Koin stays an implementation detail.
    fun greetingService(): GreetingService = koin.get()
}
