package com.github.jetbrains.swiftexport

import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// Coroutines
//
// `suspend fun` becomes `func ... async throws`, called with `try await`.
// A `suspend () -> Unit` parameter becomes an `async` Swift closure, so the closure body can `await`
// even when the caller has no async context.

class User(val name: String, val age: Int)

class UserRepository {
    suspend fun loadUsers(): List<User> {
        delay(500)
        return listOf(User("John Doe", 30), User("Jane Doe", 25))
    }

    @OptIn(DelicateCoroutinesApi::class)
    fun launch(block: suspend () -> Unit) {
        GlobalScope.launch { block() }
    }
}
