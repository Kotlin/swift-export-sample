package com.github.jetbrains.swiftexport

import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// Coroutines
//
// `suspend fun` becomes `func ... async throws`, called with `try await`.
// A `suspend () -> Unit` parameter becomes an `async` Swift closure, so the closure body can `await`
// even when the caller has no async context.
// Cancellation works both ways: cancelling the Swift `Task` cancels the coroutine, and Swift
// gets a `CancellationError`.

class User(val name: String, val age: Int)

class UserLoader {
    suspend fun loadUsers(): List<User> {
        delay(500)
        return listOf(User("John Doe", 30), User("Jane Doe", 25))
    }

    @OptIn(DelicateCoroutinesApi::class)
    fun launch(block: suspend () -> Unit) {
        GlobalScope.launch { block() }
    }
}

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
