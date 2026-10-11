package com.github.jetbrains.swiftexport

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map

// Wrapping generic classes for Swift
//
// A typical screen state is a generic sealed class: `ScreenState<T>` with `Ready<T>(data: T)`.
// Generics are erased in Swift, so `Ready.data` is `(any _KotlinBridgeable)?` and has to be cast,
// and functions that take `ScreenState<Profile>` as a parameter are not exported at all.
// The fix is a non-generic wrapper per screen (`ProfileState`), mapped from the generic class in
// Kotlin. Swift then gets typed payloads and an exhaustive `switch` without casts.

// Shared, generic code: what Android uses directly.

sealed class ScreenState<out T> {
    data object Loading : ScreenState<Nothing>()

    data class Ready<out T>(val data: T) : ScreenState<T>()

    data class Error(val message: String) : ScreenState<Nothing>()
}

data class Profile(val name: String, val followers: Int)

class ProfileLoader {
    fun load(succeed: Boolean): Flow<ScreenState<Profile>> = flow {
        emit(ScreenState.Loading)
        delay(1000)
        emit(if (succeed) ScreenState.Ready(Profile("Kodee", 2025)) else ScreenState.Error("No connection"))
    }
}

/** Not exported to Swift: a parameter of a generic class with a concrete type argument. */
fun headline(state: ScreenState<Profile>): String = when (state) {
    ScreenState.Loading -> "Loading…"
    is ScreenState.Ready -> state.data.name
    is ScreenState.Error -> state.message
}

// Swift-facing wrapper: the same states, without generics.

sealed class ProfileState {
    data object Loading : ProfileState()

    data class Ready(val profile: Profile) : ProfileState()

    data class Error(val message: String) : ProfileState()
}

class ProfileScreenModel(private val loader: ProfileLoader) {
    fun load(succeed: Boolean): Flow<ProfileState> = loader.load(succeed).map { it.toProfileState() }

    fun headline(state: ProfileState): String = headline(state.toScreenState())
}

private fun ScreenState<Profile>.toProfileState(): ProfileState = when (this) {
    ScreenState.Loading -> ProfileState.Loading
    is ScreenState.Ready -> ProfileState.Ready(data)
    is ScreenState.Error -> ProfileState.Error(message)
}

private fun ProfileState.toScreenState(): ScreenState<Profile> = when (this) {
    ProfileState.Loading -> ScreenState.Loading
    is ProfileState.Ready -> ScreenState.Ready(profile)
    is ProfileState.Error -> ScreenState.Error(message)
}
