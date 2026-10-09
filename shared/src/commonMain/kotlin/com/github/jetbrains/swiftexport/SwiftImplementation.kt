package com.github.jetbrains.swiftexport

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map

// Implementing a Kotlin interface with flows and suspend functions in Swift
//
// `UserRepository` is implemented in Swift (`SwiftUserRepository` in the iOS app) and used by
// Kotlin code (`SignInViewModel`). In Swift, `suspend fun signInUser` is `func signInUser(user:) async throws`
// and `val signedInUser: Flow<String>` is `var signedInUser: any KotlinTypedFlow<String>`.
// Swift can't create a Kotlin flow on its own, so Kotlin exports a builder for it:
// `mutableStateFlow(initial:)`. Swift keeps the returned `MutableStateFlow` and sets its `value`,
// just like an Android implementation would.

interface UserRepository {
    val signedInUser: Flow<String>
    suspend fun signInUser(user: String)
}

/** Creates a [MutableStateFlow] for Swift code, which can't call the Kotlin constructor function itself. */
fun mutableStateFlow(initial: String): MutableStateFlow<String> = MutableStateFlow(initial)

/** The Android-style implementation, for comparison. */
class InMemoryUserRepository : UserRepository {
    private val user = MutableStateFlow("")
    override val signedInUser: Flow<String> = user

    override suspend fun signInUser(user: String) {
        this.user.value = user
    }
}

/** Shared Kotlin code that only knows the interface, not who implements it. */
class SignInViewModel(private val repository: UserRepository) {
    val greeting: Flow<String> = repository.signedInUser.map { user ->
        if (user.isEmpty()) "Nobody is signed in" else "Hello, $user!"
    }

    suspend fun signIn(user: String) {
        repository.signInUser(user.trim())
    }
}
