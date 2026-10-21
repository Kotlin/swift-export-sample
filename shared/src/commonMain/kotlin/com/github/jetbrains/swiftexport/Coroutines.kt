package com.github.jetbrains.swiftexport

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.flow

class User(val name: String, val age: Int)

class UsersViewModel {
    // Flow<User> becomes `KotlinTypedFlow<User>`, consumable via `asAsyncSequence()`
    val users: Flow<User> = flow {
        for (user in loadUsers()) {
            emit(user)
            delay(500)
        }
    }

    private val _selected = MutableStateFlow<User?>(null)

    // StateFlow exposes its current `value` to Swift
    val selected: StateFlow<User?> = _selected.asStateFlow()

    // Suspend functions become Swift `async throws` functions
    suspend fun loadUsers(): List<User> {
        delay(1000)
        return listOf(User("John Doe", 30), User("Jane Doe", 25))
    }

    fun select(user: User) {
        _selected.value = user
    }

    // Suspend function types become `async` Swift closures
    suspend fun withLoading(block: suspend () -> String): String {
        delay(100)
        return "Loaded: ${block()}"
    }
}

// Cancelling the Swift Task cancels the Kotlin coroutine
suspend fun waitForever(onCancel: () -> Unit) {
    try {
        awaitCancellation()
    } catch (e: CancellationException) {
        onCancel()
        throw e
    }
}
