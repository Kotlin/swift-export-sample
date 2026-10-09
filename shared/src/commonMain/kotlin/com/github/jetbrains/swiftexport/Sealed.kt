package com.github.jetbrains.swiftexport

// Sealed classes
//
// Subclasses of a sealed class are nested Swift classes (`LoadState.Loaded`).
// `sealedType()` returns a Swift enum with one case per subclass, so Swift can `switch` over
// the hierarchy exhaustively. An `object` subclass is a singleton: `LoadState.Loading.shared`.

sealed class LoadState {
    data object Loading : LoadState()

    data class Loaded(val items: List<String>) : LoadState()

    data class Failed(val reason: String) : LoadState()
}

fun loadStateFor(step: Int): LoadState = when (step) {
    0 -> LoadState.Loading
    1 -> LoadState.Loaded(listOf("apples", "pears"))
    else -> LoadState.Failed("step $step is out of range")
}
