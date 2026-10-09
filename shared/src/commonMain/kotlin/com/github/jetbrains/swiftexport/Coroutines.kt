package com.github.jetbrains.swiftexport

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
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

    // MutableStateFlow `value` can be set from Swift
    val query: MutableStateFlow<String> = MutableStateFlow("")

    private val _events = MutableSharedFlow<String>(replay = 10)

    // SharedFlow never completes, so Swift stops collecting it with `break`
    val events: SharedFlow<String> = _events.asSharedFlow()

    // Suspend functions become Swift `async throws` functions
    suspend fun loadUsers(): List<User> {
        delay(1000)
        return listOf(User("John Doe", 30), User("Jane Doe", 25))
    }

    fun select(user: User) {
        _selected.value = user
        _events.tryEmit("Selected ${user.name}")
    }

    // Suspend function types become `async` Swift closures
    suspend fun withLoading(block: suspend () -> String): String {
        delay(100)
        return "Loaded: ${block()}"
    }
}

// Swift subclasses can override suspend functions with `async` methods
open class Repository {
    open suspend fun fetch(id: Int): String {
        delay(10)
        return "Kotlin item $id"
    }
}

suspend fun fetchAll(repository: Repository, ids: List<Int>): List<String> = ids.map { repository.fetch(it) }

// Cancelling the Swift Task cancels the Kotlin coroutine
suspend fun waitForever(onCancel: () -> Unit) {
    try {
        awaitCancellation()
    } catch (e: CancellationException) {
        onCancel()
        throw e
    }
}

// A running suspend loop is cancelled mid-delay; the flag survives for Swift to read
class Countdown {
    var wasCancelled: Boolean = false
        private set

    suspend fun run(from: Int): Int {
        try {
            for (i in from downTo 1) delay(1000)
            return from
        } catch (e: CancellationException) {
            wasCancelled = true
            throw e
        }
    }
}
